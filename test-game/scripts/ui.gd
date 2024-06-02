extends CanvasLayer

@onready var inventory_background = $InventoryBackground

func _process(_delta):
	if Input.is_action_just_pressed("open_inventory"):
		inventory_background.visible = !inventory_background.visible

func add_items(item):
	inventory_background.get_node(item + "Label").text = str(inventory_background.get_node(item + "Label").text.to_int() + 1)
