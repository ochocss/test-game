extends Control

@onready var options_menu = $OptionsMenu
@onready var controls_menu = $ControlsMenu

@onready var main_menu_container = $MainMenuContainer


var paused = false
var tab_opened = false

func _process(_delta):
	if Input.is_action_just_pressed("open_menu"):
		if controls_menu.visible == true:
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
		Engine.time_scale = 1
		hide()
	else:
		Engine.time_scale = 0
		show()
	
	paused = !paused

func _on_resume_button_pressed():
	hide()
	Engine.time_scale = 1


func _on_options_button_pressed():
	open_tab(options_menu)


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_menu_back_button_pressed():
	tab_opened = false
	options_menu.hide()
	main_menu_container.show()


func _on_controls_button_pressed():
	open_tab(controls_menu)


func open_tab(menu):
	tab_opened = true
	main_menu_container.hide()
	menu.show()
