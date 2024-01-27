extends Area2D

@onready var lure = $fishing_lure
@export var game_manager:Game_Manager
@export var turn_speed := 2.0
@export var y_limit := -650
##rotation limit for player's line
@export var line_degree_limit := 45.0

func _physics_process(delta):
	if game_manager:
		match game_manager.cur_state:
			game_manager.PLAY_STATE.LINE_UP:
				if Input.is_action_just_pressed("action1") && Input.is_action_just_pressed("action2"):
					game_manager.cur_state = game_manager.PLAY_STATE.CASTING
				turn_for_casting(delta)
			game_manager.PLAY_STATE.CASTING:
				pass
			game_manager.PLAY_STATE.CATCHING:
				pass
	
	#turn_for_casting(delta)
	
	if Input.is_action_pressed("action1"):
		lure.position.y = y_limit

func turn_for_casting(delta):
	if Input.is_action_pressed("action1") && rotation_degrees > -45:
		rotation -= turn_speed * delta
	if Input.is_action_pressed("action2") && rotation_degrees < 45:
		rotation += turn_speed * delta
