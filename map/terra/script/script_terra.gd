# Controla o fundo espacial, a interface de vida e o reinício da fase.
extends Node2D

# @onready procura cada nó somente quando esta cena já está pronta.
@onready var botao_reiniciar = $CanvasLayer/Control/BotaoReiniciar
@onready var jogador = $zeca/CharacterBody2D
@onready var barra_vida = $CanvasLayer/Control/ProgressBar

# Define quantos elementos do cenário da Terra serão criados para o fundo.
const QUANTIDADE_ELEMENTOS := 14

# Texturas reutilizadas do cenário da Terra.
const TEXTURAS_TERRA: Array[Texture2D] = [
	preload("res://map/terra/textura/C1_arvore.png"),
	preload("res://map/terra/textura/C1_carro.png"),
	preload("res://map/terra/textura/C1_casa.png"),
	preload("res://map/terra/textura/C1_pista.png")
]

# elementos_terra guarda posição, velocidade, escala e imagem de cada objeto.
var elementos_terra: Array[Dictionary] = []
# gerador escolhe valores aleatórios para os objetos aparecerem em lugares diferentes.
var gerador := RandomNumberGenerator.new()
var fundo_degrade := GradientTexture2D.new()




# --- Início da fase ---
func _ready() -> void:
	# Cria o degradê uma vez, quando a fase é iniciada.
	var degrade := Gradient.new()
	degrade.colors = PackedColorArray([
		Color("00921eff"), # verde claro no topo
		Color("003a1eff")  # verde escuro embaixo
	])
	degrade.offsets = PackedFloat32Array([0.0, 1.0])
	fundo_degrade.gradient = degrade
	fundo_degrade.fill = GradientTexture2D.FILL_LINEAR
	fundo_degrade.fill_from = Vector2(0.0, 0.5)
	fundo_degrade.fill_to = Vector2(1.0, 0.5)
	fundo_degrade.width = 256
	fundo_degrade.height = 1

	# Conecta o sinal do jogador à função que atualiza a barra de vida.
	jogador.vida_alterada.connect(atualizar_vida)
	atualizar_vida(jogador.vida)
#O botão “REINICIAR” fica escondido. (botao_reiniciar.hide())
	botao_reiniciar.hide()
	criar_elementos_terra()
# queue_redraw() pede para a Godot desenhar o cenário na tela.
	queue_redraw()

# _process roda a cada quadro; delta é o tempo passado desde o quadro anterior.
func _process(delta: float) -> void:
	# Confere o tamanho da janela para saber quando um objeto saiu da tela.
	var tamanho_tela := get_viewport_rect().size
	for elemento in elementos_terra:
		elemento["posicao"].y += elemento["velocidade"] * delta
		if elemento["posicao"].y > tamanho_tela.y + elemento["altura"]:
			elemento["posicao"] = Vector2(
				gerador.randf_range(0.0, tamanho_tela.x),
				-elemento["altura"]
			)

	# Redesenha os elementos na nova posição.
	queue_redraw()

# _draw desenha o fundo e os elementos da Terra antes dos demais nós da cena.
func _draw() -> void:
	# Desenha o degradê ocupando toda a janela.
	draw_texture_rect(
		fundo_degrade,
		Rect2(Vector2.ZERO, get_viewport_rect().size),
		false
	)

	# Desenha árvores, carros e casas por cima do fundo.
	for elemento in elementos_terra:
		var tamanho: Vector2 = elemento["tamanho"]
		var area := Rect2(elemento["posicao"] - tamanho / 2.0, tamanho)
		draw_texture_rect(elemento["textura"], area, false)

# --- Criação dos elementos do cenário terrestre ---
func criar_elementos_terra() -> void:
	elementos_terra.clear()
	# Espalha os objetos pela área visível.
	var tamanho_tela := get_viewport_rect().size

	for indice in QUANTIDADE_ELEMENTOS:
		var indice_textura := gerador.randi_range(0, TEXTURAS_TERRA.size() - 1)
		var textura: Texture2D = TEXTURAS_TERRA[indice_textura]

		var posicao_x: float
		var velocidade: float
		var escala: float

		# 0 = árvore: lados da tela
		if indice_textura == 0:
			posicao_x = [110.0, 1040.0][gerador.randi_range(0, 1)]
			velocidade = 50.0
			escala = 1

		# 1 = carro: somente no centro, onde fica a pista
		elif indice_textura == 1:
			posicao_x = gerador.randf_range(470.0, 680.0)
			velocidade = 50.0
			escala = 1

		# 2 = casa: laterais, mais perto do centro que as árvores
		elif indice_textura == 2:
			posicao_x = [260.0, 890.0][gerador.randi_range(0, 1)]
			velocidade = 50.0
			escala = 1

		# 3 = pista: sempre centralizada
		else:
			posicao_x = 576.0
			velocidade = 50.0
			escala = 1.0

		var tamanho := textura.get_size() * escala

		elementos_terra.append({
			"posicao": Vector2(
				posicao_x,
				gerador.randf_range(0.0, tamanho_tela.y)
			),
			"velocidade": velocidade,
			"textura": textura,
			"tamanho": tamanho,
			"altura": tamanho.y
		})

# Recebe a vida enviada pelo sinal vida_alterada e atualiza o ProgressBar.
func atualizar_vida(vida_atual: int) -> void:
	barra_vida.value = vida_atual

#faz o botao REINICIAR resetar a cena
func _on_botao_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()
