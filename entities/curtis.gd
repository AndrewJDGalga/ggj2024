extends Area2D

@onready var lure = $fishing_lure
@onready var anim_player = $AnimationPlayer
@onready var catch_meter = $FishCatchMeter
@export var game_manager:Game_Manager
@export var turn_speed := 2.0
##rotation limit for player's line + accuracy mod
@export var line_degree_limit := 45.0
@export var pow_gain_rate := 300.0
@export var accuracy_gain_rate := 40.0
@export var reward_ui:PackedScene
var reward_instance:Node
var cur_throw_power := 0.0
var cur_accuracy := 0.0
#tied to pow and accuracy gain
var gain_attribute := true
var rng = RandomNumberGenerator.new()

func _ready():
	catch_meter.set_meter_text("Balance the line!")

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
			game_manager.PLAY_STATE.CATCH_FAIL:
				print("Fail!")
				game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
			game_manager.PLAY_STATE.CAST_SUCCEED:
				print("cast success!")
				game_manager.cur_state = game_manager.PLAY_STATE.CATCHING
			game_manager.PLAY_STATE.CATCHING:
				pass
			game_manager.PLAY_STATE.CATCH_SUCCEED:
				print("Caught!")
				var item_data = load("res://items/Salmon.tres")
				var item_instance = item_data.duplicate()
				item_instance.item_weight = rng.randi_range(0,100)
				
				display_reward(item_instance)
				
				# close window / continue
				if (Input.is_action_pressed("action1") && Input.is_action_pressed("action2")):
					close_reward()
					game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
					
				# scrolling functionality
				if (Input.is_action_pressed("action1")):
					reward_instance.scroll_up()
				if (Input.is_action_pressed("action2")):
					reward_instance.scroll_down()
			game_manager.PLAY_STATE.TEST:
				cur_throw_power = -50
				anim_player.play("toss_lure")
				game_manager.cur_state = game_manager.PLAY_STATE.CASTING

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

func _on_fishing_lure_area_entered(_area):
	if game_manager.cur_state == game_manager.PLAY_STATE.CASTING:
		game_manager.cur_state = game_manager.PLAY_STATE.CAST_SUCCEED

func _on_animation_player_animation_finished(_anim_name):
	if game_manager.cur_state == game_manager.PLAY_STATE.CASTING:
		game_manager.cur_state = game_manager.PLAY_STATE.CATCH_FAIL
		
func display_reward(item_data:ItemData):
	if (!is_instance_valid(reward_instance)):
		reward_instance = reward_ui.instantiate()
		add_child(reward_instance)
		
	reward_instance.set_reward(item_data)

func close_reward():
	remove_child(reward_instance)
