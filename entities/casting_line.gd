extends Node2D

@onready var lure:Area2D = $fishing_lure
@export var max_speed:float = 2
@export var min_speed:float = 0.2
@export var line_limit_degree:float = 45
@export var lure_up_speed:float = 2
var horizontal_dir = 1


func _physics_process(delta):
	horizontal_swing(delta)
	
	if Input.is_action_pressed("action1"):
		lure.position.y -= 2 * delta

func horizontal_swing(delta):
	if rotation_degrees > line_limit_degree || rotation_degrees < -line_limit_degree:
		horizontal_dir *= -1
	self.rotation += min_speed * delta * horizontal_dir

