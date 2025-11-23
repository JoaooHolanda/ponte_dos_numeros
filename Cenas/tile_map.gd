#extends TileMap
#
#var colisoes_ativadas := true
#
#func _ready():
	#set_collision_state(true)
#
#
#func desativar_colisao_temporariamente():
	#if colisoes_ativadas:
		#colisoes_ativadas = false
		#set_collision_state(false)
#
#
#func reativar_colisao():
	#colisoes_ativadas = true
	#set_collision_state(true)
#
#
#func set_collision_state(ativar: bool):
	#if ativar:
		#set_collision_layer(2) # layer 1 ativo
		#set_collision_mask()
	#else:
		#set_collision_layer(0) # desliga tudo
		#set_collision_mask(0)
