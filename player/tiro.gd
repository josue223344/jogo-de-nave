extends Area2D

const SPEED = 600.0

func _physics_process(delta):
	position.y -= SPEED * delta

	if position.y < -50:
		queue_free()
