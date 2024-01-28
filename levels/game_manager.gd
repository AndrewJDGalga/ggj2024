extends Node2D

class_name Game_Manager

@onready var TimePlayer = $TimeBackground/AnimationPlayer
@onready var audio = $AudioStreamPlayer
var day_increment_timer = Timer.new()
var day_end_timer = Timer.new()
var time_hour:int = 0
var time_minutes:int = 0
var time_am = true
@export_group("TimeSystem")
@export var day_length = 30
@export var hour_start = 12
@export var hour_end = 18

@export_group("UI")
@export var ScoreText:RichTextLabel
@export var TimeText:RichTextLabel
@export var EndGameScene:Control
enum PLAY_STATE {TEST, START, LINE_UP, POWER, ACCURACY, CASTING, CATCHING, CATCH_FAIL,
	CAST_SUCCEED, CATCH_SUCCEED }
var cur_state : PLAY_STATE = PLAY_STATE.START
@export_group("Lure")
@export var lure_y_limit := -650
var score:int

@export_group("Audio")
@onready var audiostream = $AudioStreamPlayer
@export var background_music1:AudioStream 
@export var background_music2:AudioStream
@export var ambientTrack:AudioStream
@export var success:AudioStream
@export var fail:AudioStream
@export var cast:AudioStream
@export var fart1:AudioStream
@export var fart2:AudioStream
@export var fart3:AudioStream

@export_group("Items")
@export var Items:Array[ItemData]

@export_group("UI")
@export var reward_instance:Control

var rng = RandomNumberGenerator.new()

signal update_score(new_value)

func add_score(score_to_add:int):
	score += score_to_add
	ScoreText.set_text("Score: " + str(score))
	update_score.emit(score)
	
func _ready():
	# time incrementing
	time_hour = hour_start
	time_am = true if time_hour < 12 else false
	day_increment_timer.connect("timeout", increment_daytime)
	day_increment_timer.wait_time = 1
	day_increment_timer.one_shot = false
	add_child(day_increment_timer)
	day_increment_timer.start()
	
	# day end timer
	day_end_timer.connect("timeout", game_over)
	day_end_timer.wait_time = day_length
	day_end_timer.one_shot = true
	add_child(day_end_timer)
	day_end_timer.start()
	
	#update_time_ui()
	
	#TimePlayer.play("TimeOfDay")
	#TimePlayer.advance(0)
	#
	#var anim_length = TimePlayer.current_animation_length
	#TimePlayer.seek(float(hour_start)/24 * anim_length, true)
	#
	#TimePlayer.set_speed_scale(anim_length/day_length)
	
func game_over():
	$score_summary.activate_scorescreen(score)
func increment_daytime():
	var hour:float = ((hour_end-hour_start) / float(day_length)) * 60
	time_minutes += ceil(hour)
	while (time_minutes >= 60):
		time_minutes = time_minutes - 60
		time_hour += 1
	
	time_am = false if time_hour >= 12 || time_hour == 0 else true
	time_hour = time_hour % 24
	
	#update_time_ui()
	
func update_time_ui():
	var TimeEnd = "AM" if time_am else "PM"
	var time_hour_formatted = time_hour if time_hour < 13 else time_hour - 12
	if (time_hour < 12):
		time_hour_formatted += 1
	ScoreText.set_text(str(time_hour_formatted) + ":" + str(time_minutes).pad_zeros(2) + TimeEnd)

func play_fail():
	audio.stop()
	audio.set_stream(fail)
	audio.play()
	
func display_reward(item_data:ItemData):
	reward_instance.set_visible(true)
	reward_instance.set_reward(item_data)
	
func create_reward(rarity:int):
	var valid_items:Array[ItemData]
	for item in Items:
		if (item.rarity == rarity || item.rarity == rarity-1 || item.rarity == rarity+1):
			valid_items.append(item)
	
	var item_data = valid_items.pick_random()
	var item_instance = item_data.duplicate()
	item_instance.item_weight = rng.randi_range(0,100)
	add_score(item_data.score)
	display_reward(item_instance)

func close_reward():
	reward_instance.set_visible(false)
