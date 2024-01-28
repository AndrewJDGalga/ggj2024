extends Area2D

var zone_difficulty = 0
var current_puddle:Area2D

signal successful_landing(hit_area)

func get_zone_difficulty()->int:
	var temp = zone_difficulty
	zone_difficulty = 0
	return temp

func _on_area_entered(area):
	current_puddle = area
	emit_signal("successful_landing", area)


func _on_area_exited(area):
	if (area == current_puddle):
		current_puddle = null
