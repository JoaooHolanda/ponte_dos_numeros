extends Area2D

@export var id: int = 0  # 0 = opcao1, 1 = opcao2

func _on_body_entered(body):
	print("colidindo")
	if body.is_in_group("jogador"):
		get_parent().emit_signal("opcao_encostada", id)
