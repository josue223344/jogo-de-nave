extends Area2D

const SPEED = 1.0

var direction := Vector2.ZERO
var velocity := 1

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	randomize_direction()
	$Timer.start()

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()

	# Detectar colisão
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)
		var objeto = colisao.get_collider()

		if objeto.has_method("receber_dano"):
			objeto.receber_dano(1)
			queue_free()

	# Animação
	if velocity != Vector2.ZERO:
		sprite.play("idle")

func randomize_direction() -> void:
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

func _on_timer_timeout() -> void:
	randomize_direction()
