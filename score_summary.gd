extends Control

@onready var scorebox:Label = $ActualScore 

func _ready():
	visible = false

func activate_scorescreen(score:int):
	self.visible = true
	scorebox.text = str(score)


func _on_retry_button_pressed():
	get_tree().reload_current_scene()
