extends Control

@onready var meter = $GolfMeter

func start():
	meter.start()

func stop():
	meter.stop()

func get_percent():
	meter.get_percent()
