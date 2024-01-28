extends Control

func _on_play_pressed():
	$AudioStreamPlayer.stop()
	get_tree().change_scene_to_file("res://levels/mainlevel.tscn")

