extends Node2D

signal opcao_encostada(id)

@onready var jogador = $jogador

# Labels de conta e vidas
@onready var label_conta = $centralLabels/conta
@onready var label_vidas = $centralLabels/vidas

# Labels das opções
@onready var label_opcao1 = $opcao1_1/opcao1
@onready var label_opcao2 = $opcao2_2/opcao2

# Áreas de colisão
@onready var area_opcao1 = $opcao1_1
@onready var area_opcao2 = $opcao2_2

@onready var som_acerto = $somDeAcerto
@onready var som_erro = $somDeErro

var resposta_certa = 0
var vidas = 3
var indice_selecionado = 0

var tween_piscando: Tween = null

func _ready():
	randomize()

	# Conectar as Áreas2D
	area_opcao1.body_entered.connect(_on_opcao1)
	area_opcao2.body_entered.connect(_on_opcao2)

	gerar_equacao()
	atualizar_vidas()


# ======== COLISÃO ========

func _on_opcao1(body):
	if body == jogador:
		emit_signal("opcao_encostada", 0)
		indice_selecionado = 0
		iniciar_piscar(label_opcao1)

func _on_opcao2(body):
	if body == jogador:
		emit_signal("opcao_encostada", 1)
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


# ======== INPUT ========

func _input(event):
	if event.is_action_pressed("selecionar"):
		tratar_escolha()


# ======== LÓGICA ========

func tratar_escolha():
	var opcoes = [label_opcao1, label_opcao2]
	var valor = int(opcoes[indice_selecionado].text)

	if valor == resposta_certa:
		som_acerto.play()
		get_tree().change_scene_to_file("res://Cenas/end.tscn")
		
	else:
		som_erro.play()
		vidas -= 1
		atualizar_vidas()

		# ERRO → desativar colisão do player
		jogador.set_collision_layer(0)
		jogador.set_collision_mask(0)
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://Cenas/fase_1.tscn")
		

	parar_piscar()


func gerar_equacao():
	# 1. Sorteia o divisor (quem divide). 
	# Coloquei de 2 a 10 (evita dividir por 0 e dividir por 1 que é muito fácil)
	var b = randi() % 9 + 2 

	# 2. Sorteia qual deve ser a resposta certa (tabuada simples)
	var resultado_esperado = randi() % 10 + 1

	# 3. Calcula o 'a' multiplicando. Assim a divisão será sempre perfeita.
	var a = b * resultado_esperado
	
	# Define a resposta certa
	resposta_certa = resultado_esperado
	
	# Mostra na tela (usando o símbolo de divisão bonitinho)
	label_conta.text = "%d ÷ %d = ?" % [a, b]

	# gerando valor errado
	var errada = resposta_certa
	while errada == resposta_certa:
		errada += (randi() % 5 + 1) * (1 if randi() % 2 == 0 else -1)
	

	var valores = [resposta_certa, errada]

	label_opcao1.text = str(valores[0])
	label_opcao2.text = str(valores[1])

	indice_selecionado = 0


func atualizar_vidas():
	label_vidas.text = "Vidas: %d" % vidas
	if vidas <= 0:
		get_tree().reload_current_scene()
