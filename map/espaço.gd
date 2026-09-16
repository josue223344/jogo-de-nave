#Primeira parte

extends Node2D

#@onready faz uma variável ser inicializada quando o nó estiver pronto.
@onready var botao_reiniciar = $CanvasLayer/Control/BotaoReiniciar

#QUANTIDADE_ESTRELAS: define que o fundo terá 90 estrelas.
const QUANTIDADE_ESTRELAS := 90
#estrelas: guarda os dados de cada estrela, como posição, velocidade, tamanho e cor.
var estrelas: Array[Dictionary] = []
#gerador: escolhe valores aleatórios para que as estrelas apareçam em lugares diferentes.
var gerador := RandomNumberGenerator.new()

#Segunda parte

func _ready() -> void:
#O botão “REINICIAR” fica escondido. (botao_reiniciar.hide())
	botao_reiniciar.hide()
#criar_estrelas() cria as 90 estrelas.(funçao criada)
	criar_estrelas()
#queue_redraw() pede para a Godot desenhar o cenário na tela.
	queue_redraw()

#Ela é uma funçao criada para repetir 90 vezes e guarda cada estrela nova:
func criar_estrelas() -> void:
	estrelas.clear()
#espalha as estrelas por toda tela visivel
	var tamanho_tela := get_viewport_rect().size

#limita as informaçoes geradas a 90 unidades de cada
	for indice in QUANTIDADE_ESTRELAS:
#Divide as estrelas entre as camadas de 0 a 2
		var camada := gerador.randi_range(0, 2)
#define a velocidade das estrelas em cada camada
		var velocidade: float = [45.0, 90.0, 160.0][camada]
#define o tamanho das estrelas em cada camada
		var tamanho: float = [1.0, 1.5, 2.5][camada]
#aplica essa informaçoes a variavel estrela
#append() adiciona a nova estrela na lista.
		estrelas.append({
			"posicao": Vector2(gerador.randf_range(0.0, tamanho_tela.x), gerador.randf_range(0.0, tamanho_tela.y)),
			"velocidade": velocidade,
			"tamanho": tamanho,
			"cor": Color(0.55 + camada * 0.15, 0.7 + camada * 0.1, 1.0, 0.55 + camada * 0.15)
		})

#_process() é uma função chamada repetidamente enquanto o jogo está rodando
#delta é o tempo que passou desde a última atualização
func _process(delta: float) -> void:
#Aqui o jogo novamente confere o tamanho da janela, para saber quando uma estrela saiu da tela.
	var tamanho_tela := get_viewport_rect().size
#Este laço percorre todas as estrelas da lista, uma por uma.
	for estrela in estrelas:
#Essa é a linha que faz a estrela andar.
#posicao.y é a posição vertical da estrela.
#Somar um valor em y faz a estrela descer.
#velocidade * delta define quanto ela desce naquela atualização.
		estrela["posicao"].y += estrela["velocidade"] * delta
#Quando uma estrela passa da parte inferior da tela:
#Ela não é destruída. Em vez disso, ela reaparece no topo da tela, em uma posição horizontal aleatória.
		if estrela["posicao"].y > tamanho_tela.y:
#-estrela["tamanho"] faz a estrela nascer levemente acima da área visível
			estrela["posicao"] = Vector2(gerador.randf_range(0.0, tamanho_tela.x), -estrela["tamanho"])

#redesenha a estrela na nova posiçao
	queue_redraw()

#draw() é a função responsável por colocar elementos visuais na tela.
func _draw() -> void:
# Fundo escuro e estrelas em movimento, desenhados antes dos demais nós.
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("07142b"))
#O jogo pega cada estrela e desenha um pequeno círculo usando:
#a posição da estrela;
#o tamanho dela;
#a cor dela.
	for estrela in estrelas:
		draw_circle(estrela["posicao"], estrela["tamanho"], estrela["cor"])

#faz o botao REINICIAR resetar a cena
func _on_botao_reiniciar_pressed() -> void:
	get_tree().reload_current_scene()
