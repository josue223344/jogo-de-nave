extends Area2D

# Velocidade vertical do tiro, em pixels por segundo.
const SPEED = 600.0




# _ready roda uma vez quando o tiro entra na cena.
func _ready():
	# Remove o tiro após dois segundos, mesmo que ele não atinja nenhum alvo.
	await get_tree().create_timer(2.0).timeout
	queue_free()

# _physics_process atualiza o movimento em sincronia com a física.
func _physics_process(delta):
	# Subtrair no eixo Y faz o tiro subir na tela.
	position.y -= SPEED * delta

# Remove o tiro ao atingir um corpo físico.
func _on_body_entered(_body):
	queue_free()

# Este sinal acontece quando o tiro entra em outra Area2D, como um inimigo.
func _on_area_2d_body_entered(body: Node2D) -> void:
	# has_method confirma que o alvo sabe receber dano de tiro.
	if body.has_method("receber_dano_tiro"):
		body.receber_dano_tiro(1)
