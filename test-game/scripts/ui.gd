extends CanvasLayer

@onready var inventory = $Inventory
@onready var map = $Map
@onready var score_label = %ScoreLabel
@onready var green_area_button = $Map/Map/GreenAreaButton
@onready var purple_area_button = $Map/Map/PurpleAreaButton
@onready var pause_menu = $PauseMenu

var score = 0


func _ready():
	score_label.text = str(score)


func _process(_delta):
	if Input.is_action_just_pressed("open_inventory") && map.visible == false:
		if inventory.visible:
			inventory.hide()
		else:
			inventory.show()
	
	if Input.is_action_just_pressed("open_map") && inventory.visible == false:
		if map.visible:
			map.hide()
		else:
			map.show()


func add_item(item : String):
	inventory.add_item(item)


func add_point():
	score += 1
	score_label.text = str(score)


func reset_score():
	score = 0
	score_label.text = "0"


func _on_green_area_button_pressed():
	if get_tree().current_scene.name == "PurpleArea":
		map.hide()
		get_tree().change_scene_to_file("res://scenes/green_area.tscn")
		SaveFileHandler.load_game()


func _on_purple_area_button_pressed():
	if get_tree().current_scene.name == "GreenArea":
		map.hide()
		get_tree().change_scene_to_file("res://scenes/purple_area.tscn")


func save():
	var save_dict = {
		"score" : score,
	}
	return save_dict


func load_data(data : Dictionary):
	score = data.get("score")
	score_label.text = str(score)
