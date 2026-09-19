# Inimigo rápido que segue em linha reta para baixo.
extends Area2D

# Quantidade de pixels percorridos por segundo.
const SPEED = 500.0

# Estado atual do inimigo: direção, vida e se sua morte já começou.
var direction := Vector2.ZERO
var vida = 1
var inimigo_morto := false
@onready var sprite = $AnimatedSprite2D




# Escolhe a direção inicial quando o inimigo é adicionado à fase.
func _ready() -> void:
	direçao_aleatoria()

# Move o inimigo. delta impede que o FPS altere a velocidade real.
func _physics_process(delta):
	if inimigo_morto:
		return
	position -= SPEED * direction * delta
	sprite.play("idle")
	if position.y > 700:
		queue_free()

# O sinal body_entered chama esta função ao tocar um corpo, como o jogador.
func _on_area_2d_body_entered(body: Node2D) -> void:
	if inimigo_morto:
		return
	if body.has_method("receber_dano"):
		inimigo_morto = true
		body.receber_dano(1)
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()




# Recebe a quantidade de dano enviada pelo projétil.
func receber_dano_tiro(dano: int) -> void:
	if inimigo_morto:
		return
	# Atualiza a vida atual.
	vida -= dano
	# Mostra que o tiro acertou deixando o sprite vermelho por pouco tempo.
	sprite.modulate = Color(1.0, 0.291, 0.305, 1.0)
	# await espera o timer sem congelar o jogo.
	await get_tree().create_timer(0.15).timeout
	# Restaura a cor do sprite.
	sprite.modulate = Color.WHITE
	# Quando a vida termina, reproduz a animação e remove o inimigo.
	if vida <= 0:
		inimigo_morto = true
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()

# Define direction como para cima; como o movimento usa -=, o inimigo desce na tela.
func direçao_aleatoria() -> void:
	direction = Vector2(0,-1).normalized()
