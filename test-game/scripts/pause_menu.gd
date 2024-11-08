extends Control

@onready var options_menu = $OptionsMenu
@onready var controls_menu = $ControlsMenu
@onready var main_menu_container = $MainMenuContainer

var paused = false
var tab_opened = false


func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if UI.get_node("Inventory").visible == true:
			UI.get_node("Inventory").hide()
		elif UI.get_node("Map").visible == true:
			UI.get_node("Map").hide()
		
		elif controls_menu.visible == true:
			esc_action(controls_menu)
		else:
			esc_action(options_menu)


func esc_action(tab):
	# esc while some other pause menu is open
	if tab_opened:
		tab_opened = false
		tab.hide()
		main_menu_container.show()
		return
	
	# esc while the main pause menu is open
	if paused:
		unpause_game()
	else:
		pause_game()
	
	paused = !paused


func pause_game():
	Engine.time_scale = 0
	get_tree().paused = true
	show()
	
	var nodes = get_tree().get_nodes_in_group("Killzone")
	for node in nodes:
		if is_instance_of(node, Area2D):
			node.get_node("Timer").paused = true
		else:
			node.get_node("Killzone").get_node("Timer").paused = true


func unpause_game():
	Engine.time_scale = 1
	get_tree().paused = false
	hide()
	
	var nodes = get_tree().get_nodes_in_group("Killzone")
	for node in nodes:
		if is_instance_of(node, Area2D):
			node.get_node("Timer").paused = false
		else:
			node.get_node("Killzone").get_node("Timer").paused = false


func open_tab(menu):
	tab_opened = true
	main_menu_container.hide()
	menu.show()


func back_button_pressed(tab):
	tab_opened = false
	tab.hide()
	main_menu_container.show()


func _on_resume_button_pressed():
	hide()
	Engine.time_scale = 1


func _on_load_button_pressed():
	if !UI.can_interact:
		return
	if get_tree().current_scene.name == "PurpleArea":
		get_tree().change_scene_to_file("res://scenes/green_area.tscn")
		return
	SaveFileHandler.load_game()


func _on_save_button_pressed():
	if UI.can_interact:
		SaveFileHandler.save_game()


func _on_options_button_pressed():
	open_tab(options_menu)


func _on_quit_button_pressed():
	if !(get_tree().current_scene.name == "PurpleArea") && UI.can_interact:
		SaveFileHandler.save_game()
	get_tree().quit()


func _on_options_menu_back_button_pressed():
	back_button_pressed(options_menu)


func _on_controls_menu_back_button_pressed():
	back_button_pressed(controls_menu)


func _on_controls_button_pressed():
	open_tab(controls_menu)
