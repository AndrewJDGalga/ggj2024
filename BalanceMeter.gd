extends VBoxContainer

var TimeUnits = "seconds"
var new_percent = 0 # testing var for debug

# Called when the node enters the scene tree for the first time.
func _ready():
	set_balance_meter_time(5);
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	step_debug_meter()

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
func set_meter_point_percent(percent):
	var meter_size = $BalanceMeterSafeProgressBar.get_size()
	var meter_point_size = $BalanceMeterSafeProgressBar/BalanceMeterPoint.get_size()
	var new_position = percent * (meter_size.x - meter_point_size.x/2)
	$BalanceMeterSafeProgressBar/BalanceMeterPoint.position = Vector2(new_position, 0)
	
# sets the difficulty of the meter to balance on Range 0-1
func set_safe_zone_percent(percent):
	$BalanceMeterSafeProgressBar.set_value(percent*100)