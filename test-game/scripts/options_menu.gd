extends Control

signal back_button_pressed

@export
var music_bus = AudioServer.get_bus_index("Music")
var sound_effect_bus = AudioServer.get_bus_index("Sound Effects")

@onready var music_slider = %MusicSlider
@onready var sound_effect_slider = %SoundEffectSlider
@onready var screen_button = $VBoxContainer/ScreenButton


func _ready():
	var video_settings = ConfigFileHandler.load_video_settings()
	
	if screen_button.selected != video_settings.screen_mode:
		screen_button.select(video_settings.screen_mode)
		_on_screen_button_item_selected(video_settings.screen_mode)
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	
	if music_slider.value != audio_settings.music:
		music_slider.value = audio_settings.music
		_on_music_slider_value_changed(music_slider.value)
	
	if sound_effect_slider.value != audio_settings.sound_effects:
		sound_effect_slider.value = audio_settings.sound_effects
		_on_sound_effect_slider_value_changed(sound_effect_slider.value)


func _on_back_button_pressed():
	back_button_pressed.emit()


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


func _on_screen_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		ConfigFileHandler.save_video_setting("screen_mode", 0)
	elif index == 1:
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		ConfigFileHandler.save_video_setting("screen_mode", 1)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))
		ConfigFileHandler.save_video_setting("screen_mode", 2)


func _on_music_slider_drag_ended(value_changed):
	if value_changed: 
		ConfigFileHandler.save_audio_setting("music", music_slider.value)

func _on_sound_effect_slider_drag_ended(value_changed):
	if value_changed: 
		ConfigFileHandler.save_audio_setting("sound_effects", sound_effect_slider.value)
