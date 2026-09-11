extends CharacterBody2D

const SPEED = 100.0

var direction := Vector2.ZERO

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	randomize_direction()
	$Timer.start()

func _physics_process(_delta: float) -> void:
	velocity = direction * SPEED
	move_and_slide()

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
