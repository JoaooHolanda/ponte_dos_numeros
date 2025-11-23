extends Area2D

@export var id: int = 1  # 0 = opcao1, 1 = opcao2

func _on_body_entered(body):
	print("colidindo")
	if body.is_in_group("jogador"):
		# Envia sinal para o script principal
		get_tree().current_scene.emit_signal("opcao_encostada", id)
