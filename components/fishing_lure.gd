extends Area2D

var zone_difficulty = 0
var current_puddle:Area2D
var in_zone:bool = false
signal successful_landing(hit_area)

func is_in_zone()->bool:
	return in_zone

func get_zone_difficulty()->int:
	var temp = zone_difficulty
	zone_difficulty = 0
	return temp

func _on_area_entered(area):
	current_puddle = area
	emit_signal("successful_landing", area)
	in_zone = true


func _on_area_exited(area):
	in_zone = false
	if (area == current_puddle):
		current_puddle = null
