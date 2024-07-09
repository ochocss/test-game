extends CanvasLayer

@onready var inventory = $Inventory
@onready var map = $Map
@onready var score_label = %ScoreLabel

@onready var green_area_button = $Map/GreenAreaButton
@onready var purple_area_button = $Map/PurpleAreaButton

var player_current_area = "green"
var score = 0


func _ready():
	score_label.text = str(score)


func _process(_delta):
	if Input.is_action_just_pressed("open_inventory"):
		inventory.visible = !inventory.visible
	
	if Input.is_action_just_pressed("open_map"):
		map.visible = !map.visible
		purple_area_button.disabled = !purple_area_button.disabled
		green_area_button.disabled = !green_area_button.disabled


func add_item(item : String):
	inventory.add_item(item)


func add_point():
	score += 1
	score_label.text = str(score)


func _on_green_area_button_pressed():
	if get_tree().current_scene.name == "PurpleArea":
		get_tree().change_scene_to_file("res://scenes/green_area.tscn")
		player_current_area = "greem"


func _on_purple_area_button_pressed():
	if get_tree().current_scene.name == "GreenArea":
		get_tree().change_scene_to_file("res://scenes/purple_area.tscn")
		player_current_area = "purple"


func save():
	var save_dict = {
		"score" : score,
		"player_current_area" : player_current_area,
	}
	return save_dict


func load_data(data : Dictionary):
	score = data.get("score")
	score_label.text = str(score)
	
	if data.get("player_current_area") == "purple":
		_on_purple_area_button_pressed()
