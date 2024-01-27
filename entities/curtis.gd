extends Area2D

@onready var lure = $fishing_lure
@export var turn_speed := 2.0
@export var y_limit := -650
var game_manager

func _ready():
	game_manager = get_tree().root.get_child(0)

func _physics_process(delta):
	#turn_for_casting(delta)
	
	if Input.is_action_pressed("action1"):
		lure.position.y = y_limit

func turn_for_casting(delta):
	if Input.is_action_pressed("action1"):
		rotation += turn_speed * delta
	if Input.is_action_pressed("action2"):
		rotation -= turn_speed * delta
