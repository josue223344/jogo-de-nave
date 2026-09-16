#primeira parte do codigo: informaçoes

#extends significa:Este objeto vai ser baseado nesse tipo de objeto
#CharacterBody2D é um tipo de objeto para personagens que se movimentam.
extends CharacterBody2D

#const é um valor que não pode ser alterado depois de definido.
const SPEED = 300.0
const VIDA_MAXIMA = 3
#var é um valor armazenado alteravel
var vida = VIDA_MAXIMA
var pode_atirar = true
#@export permite que uma variável seja configurada pelo Inspector da Godot.
#PackedScene representa uma cena salva que pode ser carregada e usada como um molde para criar novas instâncias.
@export var tiro_scene: PackedScene
#@onready faz uma variável ser inicializada quando o nó estiver pronto.
@onready var sprite = $AnimatedSprite2D

#segunda perte do codigo: comandos

#func é simplesmente um bloco de código que executa uma determinada tarefa.
#Godot chama automaticamente _physics_process() várias vezes durante o jogo
#_delta: float representa "Quanto tempo passou desde a última vez que essa função foi executada?"
func _physics_process(_delta: float) -> void:
#ui_left,ui_right, ui_up e ui_down representam a direçao que o personagem vai andar
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
#velocity é uma var embutida em CharacterBody2D
#If: testa a primeira condição.
#Elif: avalia condições alternativas se o if inicial for falso.
#Else: executa apenas se nenhuma condição anterior for verdadeira.
	if direction:
		velocity = direction * SPEED
#Vector2.ZERO representa um vetor com X = 0 e Y = 0. Quando atribuído à velocity, faz o personagem ficar sem velocidade.
	else:
		velocity = Vector2.ZERO
#move_and_slide() manda o personagem se movimentar.
	move_and_slide()


# Aqui você está dizendo qual animação deve ser reproduzida.
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


	# Isso pergunta:"O jogador acabou de apertar o botão ui_accept?"
	#just_pressed significa:"Foi apertado agora."
	if Input.is_action_pressed("ui_accept") and pode_atirar:
		atirar()


# atirar() é uma funçao criada
func atirar() -> void:
#tiro_scene é a cena de fora que chamamos
#instantiate() cria uma copia dela
	var tiro = tiro_scene.instantiate()
#aqui fala pro tiro estar na posição igual a do zeca
	tiro.global_position = global_position
#Pegua a cena atual do jogo e coloca o novo tiro dentro dela
#get_tree():pega a árvore do jogo
#current_scene:pega a cena que está sendo executada atualmente.
#add_child(tiro):adiciona o tiro como filho dessa cena
	get_tree().current_scene.add_child(tiro)
	pode_atirar = false
	$TimerTiro.start()

func _on_timer_tiro_timeout() -> void:
	pode_atirar = true

# receber_dano é uma funçao criada, e recebe um numeri interiro(int) chamado dano
func receber_dano(dano: int) -> void:
#vida = vida - dano
	vida -= dano
#mostra a vida no console
	print("Vida: ", vida)
# Indicador visual de dano
	sprite.modulate = Color(1.0, 0.291, 0.305, 1.0)
#isso significa:"Espere 0,15 segundo antes de continuar."
	await get_tree().create_timer(0.15).timeout
#isso devolve a cor normal
	sprite.modulate = Color.WHITE
#se vida chegar a 0 a func morrer() é ativada
	if vida <= 0:
		morrer()

# morrer() foi um funçao criada
func morrer() -> void:
	print("Morreu!")
#procura um nó especifico dentro da cena
	var botao = get_tree().current_scene.get_node("CanvasLayer/Control/BotaoReiniciar")
#manda o botão aparecer.
	botao.show()
#queue_free() agenda o objeto para ser removido da árvore de cenas.
	queue_free()
