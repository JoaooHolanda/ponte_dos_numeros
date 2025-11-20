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

func _ready():
	gerar_equacao()
	atualizar_vidas()

# Gera equação aleatória de soma ou subtração sem resultado negativo
func gerar_equacao():
	var a = randi() % 50
	var b = randi() % 50

	if randi() % 2 == 0:
		tipo_operacao = "+"
		resposta_certa = a + b
	else:
		tipo_operacao = "-"
		# garante que a >= b para evitar resultado negativo
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

# Verifica se o jogador escolheu a resposta certa
func check_answer(posicao_jogador):
	for opcao in [label_opcao1, label_opcao2]:
		if opcao.get_global_rect().has_point(posicao_jogador):
			var valor = int(opcao.text)
			if valor == resposta_certa:
				tocar_acerto()
				jogador.position.x += 150
				gerar_equacao()
			else:
				tocar_erro()
				vidas -= 1
				atualizar_vidas()
				jogador.position.x -= 150
			break
	jogador.pode_escolher = true

# Atualiza HUD de vidas
func atualizar_vidas():
	label_vidas.text = "Vidas: %d" % vidas
	if vidas <= 0:
		get_tree().reload_current_scene()

# Sons
func tocar_acerto():
	som_acerto.play()

func tocar_erro():
	som_erro.play()

func atualizar_selecao():
	for opcao in [label_opcao1, label_opcao2]:
		if opcao.get_global_rect().has_point(jogador.global_position):
			opcao.self_modulate = Color(1, 1, 0.5) # amarelo claro
		else:
			opcao.self_modulate = Color(1, 1, 1) # branco
