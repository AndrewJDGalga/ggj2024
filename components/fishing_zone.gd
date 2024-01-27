extends Area2D

@onready var col = $CollisionShape2D
##Range of difficulty, where 1 is hardest and 3 is easiest
@export_range(1,5) var ease_rating:int
@export var base_size:float = 16

func _ready():
	col.shape.radius = base_size * ease_rating
