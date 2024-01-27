extends VBoxContainer

class_name MeterUIManager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Setters for UI elements. For binding to elements in the game
func set_line_meter_progress(Value):
	$LineMeter/LineMeterProgressBar.value = Value
	pass

func set_alligator_meter_progress(Value):
	$AlligatorMeter/AlligatorMeterProgressBar.value = Value
	pass
	
func set_Balance_meter_progress(Value):
	$BalanceMeter/BalanceMeterProgressBar.value = Value
	pass
