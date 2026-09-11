extends Area2D

const SPEED = 600.0

func _ready():
	await get_tree().create_timer(2.0).timeout
	queue_free()

func _physics_process(delta):
	position.y -= SPEED * delta

func _on_body_entered(_body):
	queue_free()
