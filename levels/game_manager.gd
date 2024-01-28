extends Node2D

class_name Game_Manager

@onready var TimePlayer = $TimeBackground/AnimationPlayer
@onready var time_of_day = $TimeOfDayText
@onready var audio = $AudioStreamPlayer
var timer = Timer.new()
var time_hour:int = 0
var time_minutes:int = 0
var time_am = true
@export var day_length = 30
@export var hour_start = 12
@export var hour_end = 18
enum PLAY_STATE {TEST, START, LINE_UP, POWER, ACCURACY, CASTING, CATCHING, CATCH_FAIL,
	CAST_SUCCEED, CATCH_SUCCEED }
var cur_state : PLAY_STATE = PLAY_STATE.START
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

signal update_score(new_value)

func set_score(new_score:int):
	score = new_score
	$ScoreUI.set_text("Score: " + str(score))
	update_score.emit(score)
	
func _ready():
	# time incrementing
	time_hour = hour_start
	time_am = true if time_hour < 12 else false
	timer.connect("timeout", increment_daytime)
	timer.wait_time = 1
	timer.one_shot = false
	add_child(timer)
	timer.start()
	#update_time_ui()
	
	#TimePlayer.play("TimeOfDay")
	#TimePlayer.advance(0)
	#
	#var anim_length = TimePlayer.current_animation_length
	#TimePlayer.seek(float(hour_start)/24 * anim_length, true)
	#
	#TimePlayer.set_speed_scale(anim_length/day_length)
	
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
	time_of_day.set_text(str(time_hour_formatted) + ":" + str(time_minutes).pad_zeros(2) + TimeEnd)

func play_fail():
	audio.stop()
	audio.set_stream(fail)
	audio.play()
