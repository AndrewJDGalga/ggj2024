extends Control

@onready var meter = $GolfMeter

func start():
	meter.start()

func stop():
	meter.stop()
