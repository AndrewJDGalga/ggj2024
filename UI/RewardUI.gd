extends Control

# debugging rewardUI
# @export var reward_image : Texture2D

func _ready():
	# debugging rewardUI
	# set_reward("Hello World!", reward_image)
	pass # Replace with function body.

# initializes the reward with the specified elements
func set_reward(text: String, reward_image: Texture2D):
	$VBoxContainer/RewardText.set_text(text)
	$VBoxContainer/RewardImage.set_texture(reward_image)
