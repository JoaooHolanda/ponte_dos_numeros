extends Area2D

@onready var jogador = null

func _ready():
	connect("body_entered", Callable(self, "_on_player_fall"))

func _on_player_fall(body):
	if body is CharacterBody2D:
		# REATIVA A COLISÃO DO JOGADOR
		body.ativar_colisao()

		# REINICIA A FASE
		get_tree().reload_current_scene()
