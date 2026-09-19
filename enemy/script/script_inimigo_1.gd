# Inimigo que muda de direção com um Timer e pode receber dano de tiros.
# Area2D detecta quando o inimigo toca o jogador ou um projétil.
extends Area2D

# Valores fixos da velocidade e das bordas horizontais da tela.
const SPEED = 250.0
const LIMITE_ESQUERDO = 0
const LIMITE_DIREITO = 1152

# direction guarda a direção atual; vida indica quantos tiros o inimigo suporta.
var direction := Vector2.ZERO
var vida = 2
var inimigo_morto := false
@onready var sprite = $AnimatedSprite2D




# _ready é executada uma única vez quando este inimigo entra na cena.
func _ready() -> void:
	direçao_aleatoria()
	$Timer.start()

# Atualiza o movimento usando delta para manter a velocidade igual em qualquer FPS.
func _physics_process(delta):
	if inimigo_morto:
		return
	position -= SPEED * direction * delta
	sprite.play("idle")
	if position.y > 700:
		queue_free()

# Mantém o inimigo dentro das fronteiras e inverte a direção horizontal ao tocar uma lateral.
	if position.x < LIMITE_ESQUERDO:
		position.x = LIMITE_ESQUERDO
		direction.x *= -1

	if position.x > LIMITE_DIREITO:
		position.x = LIMITE_DIREITO
		direction.x *= -1

# O sinal body_entered chama esta função quando o inimigo toca um corpo físico.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if inimigo_morto:
		return
	if body.has_method("receber_dano"):
		inimigo_morto = true
		body.receber_dano(1)
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()




# Esta função é chamada pelo tiro; dano é a quantidade de vida que será retirada.
func receber_dano_tiro(dano: int) -> void:
	if inimigo_morto:
		return
	# Subtrai o dano da vida atual.
	vida -= dano
	# Muda temporariamente a cor do sprite para avisar que o tiro acertou.
	sprite.modulate = Color(1.0, 0.291, 0.305, 1.0)
	# await espera o timer terminar sem parar o restante do jogo.
	await get_tree().create_timer(0.15).timeout
	# Devolve a cor original do sprite.
	sprite.modulate = Color.WHITE
	# Ao chegar em zero, toca a animação de morte e remove este inimigo.
	if vida <= 0:
		inimigo_morto = true
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()

# Sorteia e normaliza um vetor, mantendo a velocidade constante em qualquer direção.
func direçao_aleatoria() -> void:
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	# Repete enquanto Y é positivo para evitar uma direção que faria este inimigo subir.
	while direction.y > 0:
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()

# Sinal do Timer: escolhe uma nova direção.
func _on_timer_timeout() -> void:
	direçao_aleatoria()
