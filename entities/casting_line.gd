extends Node2D

@export var max_speed:float = 2
@export var min_speed:float = 0.2
@export var line_limit_degree:float = 45
var horizontal_dir = 1


func _physics_process(delta):
	if rotation_degrees > line_limit_degree || rotation_degrees < -line_limit_degree:
		horizontal_dir *= -1
	self.rotation += min_speed * delta * horizontal_dir

func swing():
	pass
