extends Control

var TimeUnits = "seconds"
var new_percent = 0 # testing var for debug

# optional text label for the golf meter
@export var text_label : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
	if (is_instance_valid(text_label)):
		text_label.set_text(text)
