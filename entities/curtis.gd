extends Area2D

@onready var lure = $fishing_lure
@export var game_manager:Game_Manager
@export var turn_speed := 2.0
##rotation limit for player's line + accuracy mod
@export var line_degree_limit := 45.0
@export var pow_gain_rate := 300.0
@export var accuracy_gain_rate := 40.0
var cur_throw_power := 0.0
var cur_accuracy := 0.0
#tied to pow and accuracy gain
var gain_attribute := true

func _physics_process(delta):
	if game_manager:
		match game_manager.cur_state:
			game_manager.PLAY_STATE.LINE_UP:
				if Input.is_action_just_pressed("action1") && Input.is_action_just_pressed("action2"):
					game_manager.cur_state = game_manager.PLAY_STATE.CASTING
				turn_for_casting(delta)
			game_manager.PLAY_STATE.POWER:
				if Input.is_action_pressed("action1"):
					game_manager.cur_state = game_manager.PLAY_STATE.ACCURACY
				cur_throw_power = set_attribute(
					game_manager.lure_y_limit, 0, cur_throw_power, 
					pow_gain_rate, delta)
			game_manager.PLAY_STATE.ACCURACY:
				if Input.is_action_pressed("action1"):
					game_manager.cur_state = game_manager.PLAY_STATE.CASTING
				cur_accuracy = set_attribute(
					-line_degree_limit, line_degree_limit, cur_accuracy, 
					accuracy_gain_rate, delta)
			game_manager.PLAY_STATE.CASTING:
				lure.position.y = cur_throw_power
				lure.position.x = cur_accuracy
				game_manager.cur_state = game_manager.PLAY_STATE.CASTING
			game_manager.PLAY_STATE.CATCHING:
				pass

func set_attribute(min_limit, max_limit, attribute, gain, delta)->float:
	if gain_attribute:
		attribute += gain * delta
	if !gain_attribute:
		attribute -= gain * delta
	if attribute > max_limit:
		gain_attribute = false
	if attribute < min_limit:
		gain_attribute = true
	return attribute

func turn_for_casting(delta):
	if Input.is_action_pressed("action1") && rotation_degrees > -45:
		rotation -= turn_speed * delta
	if Input.is_action_pressed("action2") && rotation_degrees < 45:
		rotation += turn_speed * delta
