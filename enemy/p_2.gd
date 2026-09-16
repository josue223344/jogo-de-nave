extends Area2D

const SPEED = 250.0
const LIMITE_ESQUERDO = 0
const LIMITE_DIREITO = 1152
const LIMITE_SUPERIOR = -70

var direction := Vector2.ZERO
var vida = 1
var inimigo_vivo := false
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	direçao_aleatoria()
	$Timer.start()

func _physics_process(delta):
	if inimigo_vivo:
		return
	position -= SPEED * direction * delta
	sprite.play("idle")
	if position.y > 700:
		queue_free()
#limite do inimigo
	if position.x < LIMITE_ESQUERDO:
		position.x = LIMITE_ESQUERDO
		direction.x *= -1

	if position.x > LIMITE_DIREITO:
		position.x = LIMITE_DIREITO
		direction.x *= -1

	if position.y < LIMITE_SUPERIOR:
		position.y = LIMITE_SUPERIOR
		direction.y *= -1

#causa dano
func _on_area_2d_body_entered(body: Node2D) -> void:
	if inimigo_vivo:
		return
	if body.has_method("receber_dano"):
		body.receber_dano(1)
		queue_free()

# receber_dano é uma funçao criada, e recebe um numeri interiro(int) chamado dano
func receber_dano_tiro(dano: int) -> void:
	if inimigo_vivo:
		return
	
#vida = vida - dano
	vida -= dano
# Indicador visual de dano
	sprite.modulate = Color(1.0, 0.291, 0.305, 1.0)
#isso significa:"Espere 0,15 segundo antes de continuar."
	await get_tree().create_timer(0.15).timeout
#isso devolve a cor normal
	sprite.modulate = Color.WHITE
#se vida chegar a 0 a func morrer() é ativada
	if vida <= 0:
		inimigo_vivo = true
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()

func direçao_aleatoria() -> void:
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	while direction.y > 0:
		direction = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		).normalized()

func _on_timer_timeout() -> void:
	direçao_aleatoria()
