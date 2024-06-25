extends Control

signal back_button_pressed

@export
var music_bus = AudioServer.get_bus_index("Music")
var sound_effect_bus = AudioServer.get_bus_index("Sound Effects")

@onready var music_slider = %MusicSlider
@onready var sound_effect_slider = %SoundEffectSlider


func _ready():
	music_slider.value = AudioServer.get_bus_volume_db(1)
	sound_effect_slider.value = AudioServer.get_bus_volume_db(2)


func _on_back_button_pressed():
	emit_signal("back_button_pressed")


func _on_music_slider_value_changed(value):
	slider_value_changed(music_bus, value)


func _on_sound_effect_slider_value_changed(value):
	slider_value_changed(sound_effect_bus, value)


func slider_value_changed(bus, value):
	AudioServer.set_bus_volume_db(bus, value)
	
	if value == -30:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)


func _on_resolution_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif index == 1:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
