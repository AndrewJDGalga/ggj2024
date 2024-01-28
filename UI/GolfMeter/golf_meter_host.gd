extends Control

@onready var meter = $GolfMeter

func start():
	print("starting")
	meter.start()

func stop():
	meter.stop()

func get_percent()->float:
	return meter.get_percent()
