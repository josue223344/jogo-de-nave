extends Node2D

@export var inimigo_scene: PackedScene

func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	spawner_inimigo()

func spawner_inimigo() -> void:
	var inimigo = inimigo_scene.instantiate()
	inimigo.global_position = Vector2(
	randf_range(100, 900),
	randf_range(-60, -10)
)
	get_tree().current_scene.add_child(inimigo)
