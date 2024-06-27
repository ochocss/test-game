extends Control


signal back_button_pressed


@onready var input_button_scene = preload("res://scenes/input_button.tscn")
@onready var input_container = $VBoxContainer/InputContainer


var input_actions = {
	"move_right": "Move Right",
	"move_left": "Move Left",
	"jump": "Jump",
	"move_down": "Move Down",
	"attack": "Attack",
	"open_inventory": "Open Inventory",
	"open_map": "Open Map"
}


var is_remapping = false
var action_to_remap = null
var remapping_button = null


func _ready():
	load_keybindings_from_settings()
	create_action_list()


func load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])


func create_action_list():
	for item in input_container.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("InputLabel")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		input_container.add_child(button)
		button.pressed.connect(on_input_button_pressed.bind(button, action))


func on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("InputLabel").text = "Press key to bind"


func _input(event):
	if is_remapping:
		if event is InputEventKey || (event is InputEventMouseButton && event.is_pressed()):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()


func update_action_list(button, event):
	button.find_child("InputLabel").text = event.as_text().trim_suffix(" (Physical)")


func _on_reset_button_pressed():
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	create_action_list()


func _on_back_button_pressed():
	emit_signal("back_button_pressed")
