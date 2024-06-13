extends CanvasLayer

@onready var inventory_background = $InventoryBackground
@onready var map = $Map

@onready var green_area_button = $Map/GreenAreaButton
@onready var purple_area_button = $Map/PurpleAreaButton

func _process(_delta):
	if Input.is_action_just_pressed("open_inventory"):
		inventory_background.visible = !inventory_background.visible
	
	if Input.is_action_just_pressed("open_map"):
		map.visible = !map.visible
		purple_area_button.disabled = !purple_area_button.disabled
		green_area_button.disabled = !green_area_button.disabled

func add_items(item):
	inventory_background.get_node(item + "Label").text = str(inventory_background.get_node(item + "Label").text.to_int() + 1)

func _on_green_area_button_pressed():
	if get_tree().current_scene.name == "PurpleArea":
		get_tree().change_scene_to_file("res://scenes/green_area.tscn")


func _on_purple_area_button_pressed():
	if get_tree().current_scene.name == "GreenArea":
		get_tree().change_scene_to_file("res://scenes/purple_area.tscn")
		
