extends CharacterBody2D

var pode_escolher = true
var velocidade = 200

@export var speed := 220.0
@export var run_speed_damping := 7.0
@export var gravity := 900.0
@export var jump_velocity := -380.0

func _physics_process(delta):
	var direcao = Vector2.ZERO

	# Movimento horizontal
	if Input.is_action_pressed("direita"):
		direcao.x += 1
	if Input.is_action_pressed("esquerda"):
		direcao.x -= 1

	if direcao.x != 0:
		velocity.x = lerp(velocity.x, speed * direcao.x, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)

	# Pulo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	# Gravidade
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


# =====================================================
#  FUNÇÕES DE COLISÃO — PARA ATRAVESSAR O CENÁRIO
# =====================================================

func desativar_colisao():
	# Desliga colisão do jogador
	set_collision_layer(0)
	set_collision_mask(0)
	print("Colisão do jogador DESATIVADA")


func ativar_colisao():
	# Liga colisão normal (layer 1, mask 1)
	set_collision_layer(1)
	set_collision_mask(1)
	print("Colisão do jogador REATIVADA")
