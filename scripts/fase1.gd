extends Node2D

signal opcao_encostada(id)

@onready var jogador = $jogador

# Labels
@onready var label_conta = $centralLabels/conta
@onready var label_vidas = $centralLabels/vidas

@onready var label_opcao1 = $opcao1_1/opcao1
@onready var label_opcao2 = $opcao2_2/opcao2

# Áreas2D das opções
@onready var area_opcao1 = $opcao1_1
@onready var area_opcao2 = $opcao2_2

# Sons
@onready var som_acerto = $somDeAcerto
@onready var som_erro = $somDeErro

var resposta_certa = 0
var vidas = 3
var indice_selecionado = 0

var tween_piscando: Tween = null


func _ready():
	randomize()

	# Conectar as Áreas2D para detectar o jogador
	area_opcao1.body_entered.connect(_on_opcao1)
	area_opcao2.body_entered.connect(_on_opcao2)

	gerar_equacao()
	atualizar_vidas()


# ============================================================
#  COLISÃO → QUANDO O JOGADOR ENCOSTA NA OPÇÃO
# ============================================================

func _on_opcao1(body):
	if body == jogador:
		indice_selecionado = 0
		iniciar_piscar(label_opcao1)

func _on_opcao2(body):
	if body == jogador:
		indice_selecionado = 1
		iniciar_piscar(label_opcao2)


func iniciar_piscar(label: Label):
	parar_piscar()

	tween_piscando = create_tween()
	tween_piscando.set_loops()

	tween_piscando.tween_property(label, "self_modulate", Color(1,1,0.4), 0.3)
	tween_piscando.tween_property(label, "self_modulate", Color(1,1,1), 0.3)


func parar_piscar():
	if tween_piscando:
		tween_piscando.kill()
		tween_piscando = null

	label_opcao1.self_modulate = Color(1,1,1)
	label_opcao2.self_modulate = Color(1,1,1)


# ============================================================
#  INPUT
# ============================================================

func _input(event):
	if event.is_action_pressed("selecionar"):
		tratar_escolha()


# ============================================================
#  LÓGICA DA ESCOLHA
# ============================================================

func tratar_escolha():
	var opcoes = [label_opcao1, label_opcao2]
	var valor = int(opcoes[indice_selecionado].text)

	# -------------------------------------
	# ACERTO
	# -------------------------------------
	if valor == resposta_certa:
		som_acerto.play()
		await get_tree().create_timer(0.7).timeout  # tempo para tocar o som
		get_tree().change_scene_to_file("res://Cenas/fase_2.tscn")
		return

	# -------------------------------------
	# ERRO
	# -------------------------------------
	som_erro.play()
	vidas -= 1
	atualizar_vidas()

	# Jogador atravessa o cenário
	jogador.set_collision_layer(0)
	jogador.set_collision_mask(0)

	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file("res://Cenas/fase_1.tscn")

	parar_piscar()


# ============================================================
#  GERAÇÃO DA CONTA
# ============================================================

func gerar_equacao():
	var a = randi() % 50
	var b = randi() % 50

	if randi() % 2 == 0:
		resposta_certa = a + b
		label_conta.text = "%d + %d = ?" % [a, b]
	else:
		if a < b:
			var t = a ; a = b ; b = t
		resposta_certa = a - b
		label_conta.text = "%d - %d = ?" % [a, b]

	# Gerar opção errada
	var errada = resposta_certa
	while errada == resposta_certa:
		errada += (randi() % 5 + 1) * (1 if randi() % 2 == 0 else -1)

	var valores = [resposta_certa, errada]
	valores.shuffle()

	label_opcao1.text = str(valores[0])
	label_opcao2.text = str(valores[1])

	indice_selecionado = 0


# ============================================================
#  VIDAS
# ============================================================

func atualizar_vidas():
	label_vidas.text = "Vidas: %d" % vidas

	if vidas <= 0:
		get_tree().reload_current_scene()
