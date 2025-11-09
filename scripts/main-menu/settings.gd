extends Panel
@onready var master_control: HSlider = $Panel/VBoxContainer/SettingsMaster/MasterControl
@onready var music_control: HSlider = $Panel/VBoxContainer/SettingsMusic/MusicControl
@onready var sfx_control: HSlider = $Panel/VBoxContainer/SetingsSFX/SFXControl

@onready var back_menu: Button = $Panel/BackMenu

func _ready() -> void:
	pass

func _on_fullscreen_control_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
