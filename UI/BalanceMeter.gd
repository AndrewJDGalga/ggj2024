extends VBoxContainer

@onready var meter = $BalanceMeterSafeProgressBar
@onready var timer = $Timer
@export var auto_slide_slow : float = 4
@export var controlled_slide_speed : float = 0.1
var TimeUnits = "seconds"
var new_percent = 0 # testing var for debug
var is_running := false
var pull_dir:int = 1
var last_dir:int = 1
var cur_point_pos:float = 0

signal has_failed

func _ready():
	set_balance_meter_time(5)

func _physics_process(delta):
	if is_running:
		#step_debug_meter()
		auto_move_point(delta)
		fail_check()

func push_point(dir:float, slow:float, dt:float):
	print(cur_point_pos)
	cur_point_pos = set_meter_point_percent(cur_point_pos + (dt/slow)*dir)
	print(cur_point_pos)

func auto_move_point(delta):
	cur_point_pos = set_meter_point_percent(cur_point_pos + delta/auto_slide_slow * pull_dir)

func fail_check():
	if cur_point_pos > meter.get_size().x || \
		cur_point_pos < (meter.get_size().x - meter.get_size().x/2):
		emit_signal("has_failed")

func stop():
	is_running = false
	timer.stop()
	reset(0.5)

func start(safe_width:float, dir_timer_amt:float):
	is_running = true
	timer.wait_time = dir_timer_amt
	timer.start()
	reset(safe_width)

func reset(new_safe_width:float):
	cur_point_pos = 0.5
	set_meter_point_percent(0.5)
	set_safe_zone_percent(new_safe_width)

# function used for debugging the meter
func step_debug_meter():
	new_percent += 0.001
	new_percent = clampf(new_percent, 0, 1)
	set_meter_point_percent(new_percent)
	set_safe_zone_percent(new_percent)

# sets the time remaining for the balance meter
func set_balance_meter_time(time: float):
	$BalanceMeterCountdown.set_text(str(time) + " " + TimeUnits);
	
# sets the meter point position relative to the bar it is attached to. Range 0-1
func set_meter_point_percent(percent)->float:
	var meter_size = $BalanceMeterSafeProgressBar.get_size()
	var meter_point_size = $BalanceMeterSafeProgressBar/BalanceMeterPoint.get_size()
	var new_position = percent * (meter_size.x - meter_point_size.x/2)
	#cur_point_pos = percent
	$BalanceMeterSafeProgressBar/BalanceMeterPoint.position = Vector2(new_position, 0)
	return percent
	
# sets the difficulty of the meter to balance on Range 0-1
func set_safe_zone_percent(percent):
	$BalanceMeterSafeProgressBar.set_value(percent*100)
	
func set_meter_text(text: String):
	$BalanceMeterText.set_text(text)

#set
func _on_timer_timeout():
	#random between 1, 0, -1
	var temp_dir = randi() % 3 -1
	if temp_dir == 0:
		pull_dir = last_dir
	else:
		last_dir = pull_dir
		pull_dir = temp_dir
	if is_running:
		timer.start()
