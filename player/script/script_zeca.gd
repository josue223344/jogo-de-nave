# Controla o jogador: movimento, tiro, vida e animações.
# CharacterBody2D fornece velocity e move_and_slide() para movimentação com colisão.
extends CharacterBody2D

# --- Configuração ---
# const guarda valores fixos, que não mudam durante o jogo.
const SPEED = 300.0
const VIDA_MAXIMA = 3

# var guarda dados que podem mudar durante a partida.
var vida = VIDA_MAXIMA
var pode_atirar = true
var esta_morrendo := false

# signal avisa outros nós quando a vida muda. A interface usa este sinal para atualizar a barra.
signal vida_alterada(vida_atual: int)

# @export mostra a variável no Inspector; PackedScene é uma cena que pode ser instanciada.
@export var tiro_scene: PackedScene
# @onready só procura o nó filho depois que a cena está pronta.
@onready var sprite = $AnimatedSprite2D




# --- Movimento e animação ---
# A Godot chama _physics_process várias vezes por segundo, em sincronia com a física.
# _delta não é usado aqui porque CharacterBody2D trabalha com velocity.
func _physics_process(_delta: float) -> void:
	# Não aceita movimento nem tiro enquanto a animação de morte acontece.
	if esta_morrendo:
		return

	# Input.get_vector transforma as quatro ações em uma direção de duas dimensões.
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")

	# velocity pertence ao CharacterBody2D. Se não há direção, Vector2.ZERO para o jogador.
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO

	# Move o personagem usando a velocidade calculada e responde às colisões físicas.
	move_and_slide()

	# Impede que o jogador saia da área visível da tela.
	var tamanho_tela := get_viewport_rect().size
	var margem := 20.0
	# clamp mantém cada coordenada entre um valor mínimo e máximo.
	global_position.x = clamp(global_position.x, margem, tamanho_tela.x - margem)
	global_position.y = clamp(global_position.y, margem, tamanho_tela.y - margem)

	# Escolhe a animação de acordo com a última direção do movimento.
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.x > 0:
		sprite.play("right")
	elif velocity.y < 0:
		sprite.play("up")
	elif velocity.y > 0:
		sprite.play("down")

	# is_action_pressed permanece verdadeiro enquanto o botão estiver segurado.
	# pode_atirar impede que muitos tiros sejam criados no mesmo instante.
	if Input.is_action_pressed("ui_accept") and pode_atirar:
		atirar()

	# ui_select recarrega a fase atual.
	if Input.is_action_just_pressed("reset"):
		resetar()




# Recomeça a fase que está aberta.
func resetar() -> void:
	get_tree().reload_current_scene()

# --- Tiro ---
# Cria um tiro na mesma posição global do jogador.
func atirar() -> void:
	# instantiate cria uma cópia da cena definida no Inspector.
	var tiro = tiro_scene.instantiate()
	tiro.global_position = global_position
	# add_child coloca o tiro na fase, para que ele seja atualizado e apareça na tela.
	get_tree().current_scene.add_child(tiro)
	# O TimerTiro libera o próximo disparo quando terminar.
	pode_atirar = false
	$TimerTiro.start()

# Sinal emitido pelo TimerTiro; permite atirar novamente.
func _on_timer_tiro_timeout() -> void:
	pode_atirar = true

# --- Vida e morte ---
# Recebe um valor inteiro de dano, diminui a vida e atualiza a interface.
func receber_dano(dano: int) -> void:
	vida -= dano
	vida_alterada.emit(vida)

	# modulate tinge temporariamente o sprite de vermelho.
	sprite.modulate = Color(0.936, 0.395, 0.135, 1.0)
	# await pausa somente esta função até o timer criado terminar.
	await get_tree().create_timer(0.15).timeout
	sprite.modulate = Color.WHITE

	if vida <= 0:
		morrer()

# Mostra o botão de reinício, toca a animação de morte e remove o jogador da cena.
func morrer() -> void:
	# Evita iniciar a morte duas vezes por colisões próximas.
	if esta_morrendo:
		return

	esta_morrendo = true
	velocity = Vector2.ZERO

	# get_node encontra o botão pelo caminho dentro da cena atual.
	var botao = get_tree().current_scene.get_node("CanvasLayer/Control/BotaoReiniciar")
	botao.show()

	sprite.play("dead")
	await sprite.animation_finished
	# queue_free remove este jogador de forma segura ao fim do quadro.
	queue_free()
