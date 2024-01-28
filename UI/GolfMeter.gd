extends Control

var TimeUnits = "seconds"
var new_percent = 0 # testing var for debug

# optional text label for the golf meter
@onready var text_label : Label = $'../Label'
@export var slide_speed = 0.8

var cur_meter_percent:float = 0.0
var meter_dir:int = 1
var is_running := true

func _process(delta):
	if is_running:
		if cur_meter_percent >= 1.0 || cur_meter_percent < 0.0:
			meter_dir *= -1
		cur_meter_percent += (delta*slide_speed)*meter_dir
		set_meter_point_percent(cur_meter_percent)

func get_percent()->float:
	return cur_meter_percent

func stop():
	is_running= false
	reset()

func start():
	is_running = true
	reset()

func reset():
	cur_meter_percent = 0.0

# function used for debugging the meter
func step_debug_meter():
	new_percent += 0.001
	new_percent = clampf(new_percent, 0, 1)
	set_meter_point_percent(new_percent)
	set_safe_zone_percent(new_percent)

# sets the meter point position relative to the bar it is attached to. Range 0-1
func set_meter_point_percent(percent):
	var meter_size = $BalanceMeterSafeProgressBar.get_size()
	var meter_point_size = $BalanceMeterSafeProgressBar/BalanceMeterPoint.get_size()
	var new_position = percent * (meter_size.x - meter_point_size.x/2)
	$BalanceMeterSafeProgressBar/BalanceMeterPoint.position = Vector2(new_position, 0)

# sets the difficulty of the meter to balance on Range 0-1
func set_safe_zone_percent(percent):
	$BalanceMeterSafeProgressBar.set_value(percent*100)

# sets the text of the meter if valid
func set_meter_text(text: String):
	if (text_label):
		text_label.text = text
