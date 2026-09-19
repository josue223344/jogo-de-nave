# Cria os dois tipos de inimigo em intervalos definidos pelos Timers da cena.
extends Node2D

# preload carrega as cenas uma vez e permite criar cópias com instantiate().
var inimigo_1 = preload("res://enemy/inimigo_1.tscn")
var inimigo_2 = preload("res://enemy/inimigo_2.tscn")




# Inicia os dois Timers assim que o spawner entra na fase.
func _ready() -> void:
	$Timer.start()
	$Timer2.start()

# Cria inimigo_1 acima da tela, em uma posição X aleatória.
func spawner_inimigo() -> void:
	var inimigo = inimigo_1.instantiate()
	inimigo.global_position = Vector2(
		randf_range(50, 900),
		randf_range(-100, -50)
	)

	get_tree().current_scene.add_child(inimigo)




# Cria inimigo_2 na mesma área de entrada.
func spawner_inimigo_2() -> void:
	var inimigo = inimigo_2.instantiate()
	inimigo.global_position = Vector2(
		randf_range(50, 900),
		randf_range(-100, -50)
	)

	get_tree().current_scene.add_child(inimigo)

# Sinal do primeiro Timer: chama o spawner do inimigo 1.
func _on_timer_timeout() -> void:
	spawner_inimigo()

# Sinal do segundo Timer: chama o spawner do inimigo 2.
func _on_timer_2_timeout() -> void:
	spawner_inimigo_2()
