extends Area2D

const SPEED = 100.0

var direction := Vector2.ZERO
var vida = 1
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	direçao_aleatoria()
	$Timer.start()

func _physics_process(delta):
	position -= SPEED * direction * delta
	sprite.play("idle")

#causa dano
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("receber_dano"):
		body.receber_dano(1)
		queue_free()

# receber_dano é uma funçao criada, e recebe um numeri interiro(int) chamado dano
func receber_dano_tiro(dano: int) -> void:
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
		queue_free()

func direçao_aleatoria() -> void:
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _on_timer_timeout() -> void:
	direçao_aleatoria()
