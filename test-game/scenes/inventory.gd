extends Control

@onready var grid_container = $MarginContainer/GridContainer


func add_item(item : String):
	var label_node = grid_container.get_node(item + "Label")
	label_node.text = str(label_node.text.to_int() + 1) + " " + item.to_lower()
