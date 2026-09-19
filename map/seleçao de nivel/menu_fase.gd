# Controla os botões do mapa de seleção de fases.
extends Control

# Escalas usadas para o tamanho normal e o destaque dos ícones de fase.
const ESCALA_NORMAL := Vector2(3, 3)
const ESCALA_DESTAQUE := Vector2(3.3, 3.3)

# Referência ao texto que mostra o nome do local sob o mouse.
@onready var nome_do_local: Label = $NomeDoLocal




# Abre a fase Campo de Meteoros quando o botão é pressionado.
func _on_meteoros_button_down() -> void:
	get_tree().change_scene_to_file("res://map/espaço/espaço.tscn")

func _on_terra_button_down() -> void:
	get_tree().change_scene_to_file("res://map/terra/terra.tscn")

func _on_local_base_pressed() -> void:
	get_tree().change_scene_to_file("res://map/base inimiga/base_inimiga.tscn")

func _on_base_mouse_entered() -> void:
	nome_do_local.text = "BASE INIMIGA"
	mudar_tamanho($base, ESCALA_DESTAQUE)
	mudar_tamanho($base, ESCALA_NORMAL)

func _on_terra_mouse_entered() -> void:
	nome_do_local.text = "TERRA"
	mudar_tamanho($terra, ESCALA_DESTAQUE)
	mudar_tamanho($terra, ESCALA_NORMAL)

func _on_meteoros_mouse_entered() -> void:
	nome_do_local.text = "CAMPO DE METEOROS"
	mudar_tamanho($meteoros, ESCALA_DESTAQUE)
	mudar_tamanho($meteoros, ESCALA_NORMAL)




# create_tween anima uma propriedade aos poucos, em vez de mudar instantaneamente.
func mudar_tamanho(botao: TextureButton, nova_escala: Vector2) -> void:
	var animacao := create_tween()
	animacao.tween_property(botao, "scale", nova_escala, 0.12)
# Abre a fase Terra quando o botão é pressionado.
# Abre a fase Base Inimiga quando o botão é pressionado.
# Mostra o nome da Base e cria uma animação de escala para seu botão.
# Mostra o nome da Terra e cria uma animação de escala para seu botão.
# Mostra o nome do Campo de Meteoros e cria uma animação de escala para seu botão.
