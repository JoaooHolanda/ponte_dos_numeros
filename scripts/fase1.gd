extends Node2D

@onready var jogador = $jogador

var resposta_certa = 0
var blocos = []
var vidas = 3

func _ready():
	#var cena_jogador = preload("res://Cenas/jogador.tscn")
	jogador.position = position
	gerar_pergunta()
	atualizar_vidas()

func gerar_pergunta():
	var a = randi() % 50
	var b = randi() % 50
	resposta_certa = a + b
	$hud/conta.text = "%d + %d = ?" % [a, b]
	gerar_blocos([resposta_certa, resposta_certa + 1, resposta_certa - 1])

func gerar_blocos(valores):
	blocos.clear()
	for i in range(3):
		var bloco = criar_bloco(valores[i], Vector2(200 + i * 150, 400))
		blocos.append(bloco)

func criar_bloco(valor, pos):
	var bloco = Node2D.new()
	var label = Label.new()
	label.text = str(valor)
	bloco.position = pos
	bloco.add_child(label)
	bloco.set_meta("valor", valor)
	add_child(bloco)
	return bloco


func tocar_acerto():
	$somDeAcerto.play()

func tocar_erro():
	$somDeErro.play()

func check_answer(posicao_jogador):
	for bloco in blocos:
		if bloco.get_global_rect().has_point(posicao_jogador):
			var valor = bloco.get_meta("valor")
			if valor == resposta_certa:
				tocar_acerto()
				jogador.position.x += 150
				gerar_pergunta()
			else:
				tocar_erro()
				vidas -= 1
				atualizar_vidas()
				jogador.position.x -= 150
			break
	jogador.pode_escolher = true

func atualizar_vidas():
	$hud/vidas.text = "Vidas: %d" % vidas
	if vidas <= 0:
		get_tree().reload_current_scene()
