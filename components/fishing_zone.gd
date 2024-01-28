extends Area2D

@onready var col = $CollisionShape2D
@onready var anim = $AnimatedSpriteZone
@onready var anim_player = $AnimationPlayer
##Range of difficulty, where 1 is hardest and 3 is easiest
@export_range(1,5) var ease_rating:int = 1
@export var base_size:float = 16

func _ready():
	col.shape.radius = base_size * ease_rating
	anim.set_scale(Vector2(ease_rating*2, ease_rating*2))
	anim.play("default")
	
func set_enabled(enabled:bool):
	col.call_deferred("set_disabled", !enabled)
	if (enabled):
		anim_player.play_backwards("FadeRipple")
	else:
		anim_player.play("FadeRipple")
	


func _on_area_entered(_area):
	set_enabled(false)
	$ZoneCooldown.start()


func _on_timer_timeout():
	set_enabled(true)


func _on_animation_player_animation_finished(_anim_name):
	pass # Replace with function body.
