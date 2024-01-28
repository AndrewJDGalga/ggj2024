extends Control

# debugging rewardUI
# @export var reward_image : Texture2D
var scroll_line := 0
@export var reward_weight = ["Puny", "Medium", "Large", "BIG MAMMA"]
@export var base_desc_text:String

func _ready():
	# debugging rewardUI
	# set_reward("Hello World!", reward_image)
	pass # Replace with function body.

# initializes the reward with the specified elements
func set_reward(item_data:ItemData):
	var desc = $Panel/VBoxContainer/RewardDescription
	$Panel/VBoxContainer/RewardText.set_text("[center]" + str(item_data.item_desc) + "[/center]")
	$Panel/VBoxContainer/CenterContainer/RewardImage.set_texture(item_data.item_texture)
	#var FormatText = base_desc_text % [item_data.item_name, item_data.rarity, reward_weight, item_data.score]
	var FormatText:String = base_desc_text;
	var string_size:String;
	if (item_data.item_weight > 0):
		string_size = reward_weight[0]
	if (item_data.item_weight > 25):
		string_size = reward_weight[1]
	if (item_data.item_weight > 50):
		string_size = reward_weight[2]
	if (item_data.item_weight > 75):
		string_size = reward_weight[3]
	FormatText = FormatText.format({"name": item_data.item_name, "size": string_size, "score": item_data.score, "weight": item_data.item_weight})
	desc.set_text("[center]" + FormatText + "[/center]")

# scrolls the text up if available
func scroll_up():
	scroll_line = clamp(scroll_line-1, 0, $Panel/VBoxContainer/RewardText.get_line_count())
	$Panel/VBoxContainer/RewardText.scroll_to_line(scroll_line)

# scrolls the text downwards if available
func scroll_down():
	scroll_line = clamp(scroll_line+1, 0, $Panel/VBoxContainer/RewardText.get_line_count())
	$Panel/VBoxContainer/RewardText.scroll_to_line(scroll_line)
