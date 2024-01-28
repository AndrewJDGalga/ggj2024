extends Area2D

@onready var col = $CollisionShape2D
@onready var anim = $AnimatedSpriteZone

##Range of difficulty, where 1 is hardest and 3 is easiest
@export_range(1,5) var ease_rating:int
@export var base_size:float = 16

func _ready():
	col.shape.radius = base_size * ease_rating
	anim.set_scale(Vector2(ease_rating*2, ease_rating*2))
	anim.play("default")
	
func set_enabled(enabled:bool):
	col.set_disabled(!enabled)
	if (enabled):
		$AnimationPlayer.play_backwards("FadeRipple")
	else:
		$AnimationPlayer.play("FadeRipple")
	


func _on_area_entered(area):
	set_enabled(false)
	$ZoneCooldown.start()


func _on_timer_timeout():
	set_enabled(true)


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.
