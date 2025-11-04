extends Control



func _ready():
	$Musica_theme.play()
	
	

func _on_button_jogar_pressed():
	#get_tree().change_scene()
	print("Jogando")

func _on_button_configurar_pressed():
	print("Configurando")

func _on_button_creditos_pressed():
	print("Creditando")

func _on_button_sair_pressed():
	get_tree().quit()
"res://Assets/musics/Lord Of The Rings _ The Shire _ Ambience & Music _ 3 Hours [HFlxEM6zZsc].mp3"
