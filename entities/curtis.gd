extends Area2D

@onready var lure = $fishing_lure
@export var game_manager:Game_Manager
@export var turn_speed := 2.0
##rotation limit for player's line
@export var line_degree_limit := 45.0
@export var pow_gain_rate := 300.0
var cur_throw_power := 0.0
var gain_power := true

func _physics_process(delta):
	if game_manager:
		match game_manager.cur_state:
			game_manager.PLAY_STATE.LINE_UP:
				if Input.is_action_just_pressed("action1") && Input.is_action_just_pressed("action2"):
					game_manager.cur_state = game_manager.PLAY_STATE.CASTING
				turn_for_casting(delta)
			game_manager.PLAY_STATE.POWER:
				if gain_power:
					cur_throw_power -= pow_gain_rate * delta
				if !gain_power:
					cur_throw_power += pow_gain_rate * delta
				if cur_throw_power <= game_manager.lure_y_limit:
					gain_power = false
				if cur_throw_power >= 0:
					gain_power = true
				print(cur_throw_power)
			game_manager.PLAY_STATE.CASTING:
				pass
			game_manager.PLAY_STATE.CATCHING:
				pass
	
	#turn_for_casting(delta)
	
	if Input.is_action_pressed("action1"):
		lure.position.y = game_manager.lure_y_limit

func turn_for_casting(delta):
	if Input.is_action_pressed("action1") && rotation_degrees > -45:
		rotation -= turn_speed * delta
	if Input.is_action_pressed("action2") && rotation_degrees < 45:
		rotation += turn_speed * delta
