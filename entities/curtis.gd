extends Area2D

@onready var lure = $fishing_lure
@onready var anim_player = $AnimationPlayer
@onready var catch_meter = $FishCatchMeter
@onready var accuracy_meter = $GolfMeterH
@onready var pow_meter = $GolfMeterV
@export var game_manager:Game_Manager
@export var tut_text:ColorRect
@export var turn_speed := 2.0
##rotation limit for player's line + accuracy mod
@export var line_degree_limit := 45.0
@export var pow_gain_rate := 300.0
@export var accuracy_gain_rate := 40.0
var cur_throw_power := 0.0
var cur_accuracy := 0.0
#tied to pow and accuracy gain
var gain_attribute := true
var gave_loot = false

func _ready():
	catch_meter.set_meter_text("Balance the line!")
	catch_meter.visible = false
	accuracy_meter.visible = false
	pow_meter.visible = false
	tut_text.visible = true

func _physics_process(delta):
	if game_manager:
		match game_manager.cur_state:
			game_manager.PLAY_STATE.START:
				#can't assign labels at _ready successfully
				accuracy_meter.set_label("Accuracy")
				pow_meter.set_label("Power")
				game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
			game_manager.PLAY_STATE.LINE_UP:
				lure.position = Vector2.ZERO
				tut_text.set_label_text("Press Action3 when lined up.")
				#if Input.is_action_just_pressed("action1") && Input.is_action_just_pressed("action2"):
				if Input.is_action_just_pressed("action3"):
					tut_text.set_label_text("Press Action1 to set Power.")
					pow_meter.visible = true
					pow_meter.start()
					game_manager.cur_state = game_manager.PLAY_STATE.POWER
				turn_for_casting(delta)
			game_manager.PLAY_STATE.POWER:
				lure.position.y = game_manager.lure_y_limit * pow_meter.get_percent()
				if Input.is_action_pressed("action1"):
					tut_text.set_label_text("Press Action2 to set Accuracy.")
					accuracy_meter.visible = true
					accuracy_meter.start()
					#lure.position.y = game_manager.lure_y_limit * pow_meter.get_percent()
					pow_meter.stop()
					pow_meter.visible = false
					game_manager.cur_state = game_manager.PLAY_STATE.ACCURACY
				cur_throw_power = set_attribute(
					game_manager.lure_y_limit, 0, cur_throw_power, 
					pow_gain_rate, delta)
			game_manager.PLAY_STATE.ACCURACY:
				lure.position.x = line_degree_limit * accuracy_meter.get_percent()
				if Input.is_action_pressed("action2"):
					accuracy_meter.stop()
					accuracy_meter.visible = false
					game_manager.cur_state = game_manager.PLAY_STATE.CASTING
				cur_accuracy = set_attribute(
					-line_degree_limit, line_degree_limit, cur_accuracy, 
					accuracy_gain_rate, delta)
				anim_player.play("toss_lure")
			game_manager.PLAY_STATE.CASTING:
				game_manager.cur_state = game_manager.PLAY_STATE.CATCH_SUCCEED
				#lure.position.y = cur_throw_power
				#lure.position.x = cur_accuracy
			game_manager.PLAY_STATE.CATCH_FAIL:
				game_manager.play_fail()
				game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
			game_manager.PLAY_STATE.CAST_SUCCEED:
				#TODO success notice
				catch_meter.visible = true
				game_manager.cur_state = game_manager.PLAY_STATE.CATCHING
			game_manager.PLAY_STATE.CATCHING:
				tut_text.set_label_text("Press Action1 or Action2 to balance!")
				if Input.is_action_pressed("action1"):
					catch_meter.push_point(1, 2.0, delta)
				if Input.is_action_pressed("action2"):
					catch_meter.push_point(-1, 2.0, delta)
			game_manager.PLAY_STATE.CATCH_SUCCEED:
				if (!gave_loot):
					gave_loot = true
					game_manager.create_reward(lure.current_puddle.rarity)
					lure.current_puddle.set_on_cooldown()
				# close window / continue
				if (Input.is_action_pressed("action3")):
					game_manager.close_reward()
					gave_loot = false
					game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
				# scrolling functionality
				if (Input.is_action_pressed("action1")):
					game_manager.reward_instance.scroll_up()
				if (Input.is_action_pressed("action2")):
					game_manager.reward_instance.scroll_down()
			game_manager.PLAY_STATE.CATCH_FAIL:
				#TODO fail notice
				game_manager.cur_state = game_manager.PLAY_STATE.LINE_UP
			game_manager.PLAY_STATE.TEST:
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


func _on_animation_player_animation_finished(_anim_name):
	if game_manager.cur_state == game_manager.PLAY_STATE.CASTING:
		game_manager.cur_state = game_manager.PLAY_STATE.CATCH_FAIL


func _on_fishing_lure_successful_landing(hit_area):
	if game_manager.cur_state == game_manager.PLAY_STATE.CASTING:
		game_manager.cur_state = game_manager.PLAY_STATE.CAST_SUCCEED


func _on_fish_catch_meter_has_failed():
	print("fail")
	if game_manager.cur_state == game_manager.PLAY_STATE.CATCHING:
		game_manager.cur_state = game_manager.PLAY_STATE.CATCH_FAIL
