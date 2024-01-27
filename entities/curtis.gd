extends Area2D

##amount of wobble while Curtis is sitting still
@export var base_wobble:float = 2.0
##amount curtis wobbles towards left or right while walking
@export var walk_wobble:float = 4.0

func _physics_process(delta):
	random_wobble(base_wobble, delta)

func random_wobble(max, dt):
	self.position += Vector2(randf_range(0,max), randf_range(0,max)) * dt

#random val between 0 and max
#func get_random_val(max)->float:
	#return 
