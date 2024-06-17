extends Control

@onready var options_menu = $OptionsMenu
@onready var margin_container = $MarginContainer

var paused = false
var options_opened = false

func _process(_delta):
	if Input.is_action_just_pressed("open_menu"):
		esc_action()

func esc_action():
	if options_opened:
		options_opened = false
		options_menu.hide()
		margin_container.show()
		return
	
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
	options_opened = true
	margin_container.hide()
	options_menu.show()


func _on_quit_button_pressed():
	get_tree().quit()


func _on_options_menu_back_button_pressed():
	options_menu.hide()
	margin_container.show()
