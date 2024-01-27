extends Control

# debugging rewardUI
# @export var reward_image : Texture2D
var scroll_line := 0

func _ready():
	# debugging rewardUI
	# set_reward("Hello World!", reward_image)
	pass # Replace with function body.

# initializes the reward with the specified elements
func set_reward(item_data:ItemData):
	$VBoxContainer/RewardText.set_text("[center]" + str(item_data.item_name) + "[/center]")
	$VBoxContainer/CenterContainer/RewardImage.set_texture(item_data.item_texture)

# scrolls the text up if available
func scroll_up():
	scroll_line = clamp(scroll_line-1, 0, $VBoxContainer/RewardText.get_line_count())
	$VBoxContainer/RewardText.scroll_to_line(scroll_line)

# scrolls the text downwards if available
func scroll_down():
	scroll_line = clamp(scroll_line+1, 0, $VBoxContainer/RewardText.get_line_count())
	$VBoxContainer/RewardText.scroll_to_line(scroll_line)