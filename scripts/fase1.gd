extends Node2D

@onready var jogador = $jogador
@onready var label_conta = $centralLabels/conta
@onready var label_opcao1 = $centralLabels/opcao1
@onready var label_opcao2 = $centralLabels/opcao2
@onready var label_vidas = $centralLabels/vidas
@onready var som_acerto = $somDeAcerto
@onready var som_erro = $somDeErro

var resposta_certa = 0
var tipo_operacao = "+"
var vidas = 3
var indice_selecionado = 0 # 0 = opcao1, 1 = opcao2

func _ready():
	gerar_equacao()
	atualizar_vidas()

func _process(delta):
	atualizar_selecao()

func _input(event):
	if event.is_action_pressed("direita") or event.is_action_pressed("ui_right"):
		indice_selecionado = min(indice_selecionado + 1, 1)
	elif event.is_action_pressed("esquerda") or event.is_action_pressed("ui_left"):
		indice_selecionado = max(indice_selecionado - 1, 0)
	elif event.is_action_pressed("selecionar") and jogador.pode_escolher:
		var opcao_escolhida = [label_opcao1, label_opcao2][indice_selecionado]
		var valor = int(opcao_escolhida.text)
		if valor == resposta_certa:
			tocar_acerto()
			print("Resposta correta:", valor)
			get_tree().change_scene_to_file("res://Cenas/fase_2.tscn")
		else:
			tocar_erro()
			vidas -= 1
			atualizar_vidas()
		jogador.pode_escolher = true

func gerar_equacao():
	var a = randi() % 50
	var b = randi() % 50

	if randi() % 2 == 0:
		tipo_operacao = "+"
		resposta_certa = a + b
	else:
		tipo_operacao = "-"
		if a < b:
			var temp = a
			a = b
			b = temp
		resposta_certa = a - b

	label_conta.text = "%d %s %d = ?" % [a, tipo_operacao, b]

	var deslocamento = randi() % 5 + 1
	var direcao = 1 if randi() % 2 == 0 else -1
	var errada = resposta_certa + deslocamento * direcao

	var valores = [resposta_certa, errada]
	valores.shuffle()

	label_opcao1.text = str(valores[0])
	label_opcao2.text = str(valores[1])
	indice_selecionado = 0 # reinicia seleção

func atualizar_vidas():
	label_vidas.text = "Vidas: %d" % vidas
	if vidas <= 0:
		get_tree().reload_current_scene()

func tocar_acerto():
	som_acerto.play()

func tocar_erro():
	som_erro.play()

func atualizar_selecao():
	var opcoes = [label_opcao1, label_opcao2]
	for i in range(opcoes.size()):
		opcoes[i].self_modulate = Color(1, 1, 1) # branco
	opcoes[indice_selecionado].self_modulate = Color(1, 1, 0.5) # amarelo claro
