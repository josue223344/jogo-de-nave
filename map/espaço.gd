extends Node2D

@onready var botao_reiniciar = $CanvasLayer/Control/BotaoReiniciar

func _ready() -> void:
	botao_reiniciar.hide()

func _on_botao_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()
