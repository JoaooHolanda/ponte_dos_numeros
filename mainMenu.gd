extends Control

func _on_button_jogar_pressed():
	#get_tree().change_scene()
	print("Jogando")

func _on_button_configurar_pressed():
	print("Configurando")

func _on_button_creditos_pressed():
	print("Creditando")

func _on_button_sair_pressed():
	get_tree().quit()
