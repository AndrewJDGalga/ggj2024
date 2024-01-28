extends Area2D

var zone_difficulty = 0

signal successful_landing

func get_zone_difficulty()->int:
	var temp = zone_difficulty
	zone_difficulty = 0
	return temp

func _on_area_entered(_area):
	emit_signal("successful_landing")
