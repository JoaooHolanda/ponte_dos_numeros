extends CharacterBody2D

const SPEED = 200
const GRAVITY = 900
const JUMP_FORCE = -400

var pode_escolher = true

func _physics_process(delta):
	velocity.y += GRAVITY * delta
	var direcao = Input.get_axis("ui_left", "ui_right")
	velocity.x = direcao * SPEED

	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_FORCE

	if Input.is_action_just_pressed("ui_select") and pode_escolher:
		pode_escolher = false
		get_tree().current_scene.check_answer(global_position)

	move_and_slide()
