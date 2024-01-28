extends Control

@onready var meter = $GolfMeter

func set_label(new_name:String):
	meter.set_meter_text(new_name)

func start():
	print("starting")
	meter.start()

func stop():
	meter.stop()

func get_percent()->float:
	return meter.get_percent()
