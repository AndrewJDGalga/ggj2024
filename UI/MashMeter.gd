extends VBoxContainer

var linemeter_progress = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	linemeter_progress += 0.1
	set_line_meter_percent(linemeter_progress);
	pass
	
func set_line_meter_percent(percent):
	$MashMeterProgressBar.set_value(percent)
	pass
	
func set_meter_text(text: String):
	$MashMeterText.set_text(text)
