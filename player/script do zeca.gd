extends CharacterBody2D

const SPEED = 300.0

@export var tiro_scene: PackedScene

@onready var sprite = $AnimatedSprite2D

# Movimentação
func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

# Animação
	if velocity == Vector2.ZERO:
		sprite.play("idle")
	elif velocity.x < 0:
		sprite.play("left")
	elif velocity.x > 0:
		sprite.play("right")


	# Atirar
	if Input.is_action_just_pressed("ui_accept"):
		atirar()


func atirar() -> void:
	var tiro = tiro_scene.instantiate()
	tiro.global_position = global_position
	get_tree().current_scene.add_child(tiro)
