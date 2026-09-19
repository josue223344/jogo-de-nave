# Cria inimigos periodicamente na fase Terra.
extends Node2D

# preload deixa as cenas disponíveis para instantiate sem precisar carregá-las depois.
var inimigo_1 = preload("res://enemy/inimigo_1.tscn")
var inimigo_2 = preload("res://enemy/inimigo_2.tscn")




# Inicia os Timers configurados na cena.
func _ready() -> void:
	$Timer.start()
	$Timer2.start()

# Cria o inimigo 1 em uma posição aleatória acima da área visível.
func spawner_inimigo() -> void:
	var inimigo = inimigo_1.instantiate()
	inimigo.global_position = Vector2(
		randf_range(50, 900),
		randf_range(-100, -50)
	)

	get_tree().current_scene.add_child(inimigo)




# Cria o inimigo 2 na mesma faixa de entrada.
func spawner_inimigo_2() -> void:
	var inimigo = inimigo_2.instantiate()
	inimigo.global_position = Vector2(
		randf_range(50, 900),
		randf_range(-100, -50)
	)

	get_tree().current_scene.add_child(inimigo)

# Sinal emitido pelo primeiro Timer.
func _on_timer_timeout() -> void:
	spawner_inimigo()

# Sinal emitido pelo segundo Timer.
func _on_timer_2_timeout() -> void:
	spawner_inimigo_2()
