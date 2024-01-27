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
				set_power(delta)
			game_manager.PLAY_STATE.ACCURACY:
				set_accuracy(delta)
			game_manager.PLAY_STATE.CASTING:
				pass
			game_manager.PLAY_STATE.CATCHING:
				pass

func set_accuracy(delta):
	if gain_attribute:
		cur_accuracy += accuracy_gain_rate * delta
	if !gain_attribute:
		cur_accuracy -= accuracy_gain_rate * delta
	if cur_accuracy > line_degree_limit:
		gain_attribute = false
	if cur_accuracy < -line_degree_limit:
		gain_attribute = true
	print(cur_accuracy)
	if Input.is_action_pressed("action1"):
		game_manager.cur_state = game_manager.PLAY_STATE.CASTING
		print(cur_accuracy)

func set_power(delta):
	if gain_attribute:
		cur_throw_power -= pow_gain_rate * delta
	if !gain_attribute:
		cur_throw_power += pow_gain_rate * delta
	if cur_throw_power <= game_manager.lure_y_limit:
		gain_attribute = false
	if cur_throw_power >= 0:
		gain_attribute = true
	print(cur_throw_power)
	if Input.is_action_pressed("action1"):
		game_manager.cur_state = game_manager.PLAY_STATE.ACCURACY
		print(cur_throw_power)

func turn_for_casting(delta):
	if Input.is_action_pressed("action1") && rotation_degrees > -45:
		rotation -= turn_speed * delta
	if Input.is_action_pressed("action2") && rotation_degrees < 45:
		rotation += turn_speed * delta
