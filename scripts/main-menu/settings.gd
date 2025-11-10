#extends Control
#
#@onready var main_menu_button: VBoxContainer = $Panel/MainMenuButton
#@onready var choice_game: Panel = $Panel/ChoiceGame
#@onready var continue_game: Button = $Panel/ChoiceGame/HBoxContainer/ContinueGame
#@onready var editor_player: Panel = $Panel/EditorPlayer
#@onready var privacy_policy: Control = $PrivacyPolicy
#
#var settings_scene = preload("res://scenes/settings-menu/settingsMenu.tscn")
#var settings_instance = null
#
## Создаём overlay для затемнения
#var overlay: ColorRect
#
#func _ready() -> void:
	#main_menu_button.visible = false
	#choice_game.visible = false
	#editor_player.visible = false
	#privacy_policy.visible = true
	#continue_game.disabled = not Global.has_valid_save()
	#
	## Создаём затемняющий оверлей
	#overlay = ColorRect.new()
	#overlay.color = Color(0, 0, 0, 0.7)
	#overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	#overlay.visible = false
	#add_child(overlay)
#
#func _input(event: InputEvent) -> void:
	## ESC для закрытия настроек
	#if event.is_action_pressed("ui_cancel") and settings_instance:
		#_close_settings()
#
#func _on_start_pressed() -> void:
	#main_menu_button.visible = false
	#choice_game.visible = true
#
#func _on_settings_pressed() -> void:
	#main_menu_button.visible = false
	#overlay.visible = true
	#
	#settings_instance = settings_scene.instantiate()
	#add_child(settings_instance)
#
#func _close_settings() -> void:
	#if settings_instance:
		#settings_instance.queue_free()
		#settings_instance = null
	#
	#overlay.visible = false
	#main_menu_button.visible = true
#
#func _on_quit_pressed() -> void:
	#get_tree().quit()
#
#func _on_back_menu_pressed() -> void:
	#if settings_instance:
		#_close_settings()
	#else:
		#main_menu_button.visible = true
		#choice_game.visible = false
#
#func _on_new_game_pressed() -> void:
	#Global.gold = 0
	#Global.gold_minus = 100
	#Global.save_game()
	#choice_game.visible = false
	#editor_player.visible = true
#
#func _on_continue_game_pressed() -> void:
	#Global.load_game()
	#get_tree().change_scene_to_file("res://scenes/main-menu-level/levelTest.tscn")
#
#func _on_start_new_game_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/main-menu-level/levelTest.tscn")
	#
#func _on_back_to_load_pressed() -> void:
	#editor_player.visible = false
	#choice_game.visible = true
#
#func _on_accept_privacy_pressed() -> void:
	#Settings.policy_accepted = true
	#Settings.save_settings()
	#main_menu_button.visible = true
	#privacy_policy.visible = false


extends Panel
# Этот скрипт нужно привязать к корневой ноде Settings в settingsMenu.tscn

@onready var master_slider: HSlider = $Panel/VBoxContainer/SettingsMaster/MasterControl
@onready var music_slider: HSlider = $Panel/VBoxContainer/SettingsMusic/MusicControl
@onready var sfx_slider: HSlider = $Panel/VBoxContainer/SetingsSFX/SFXControl
@onready var fullscreen_toggle: CheckButton = $Panel/FullscreenControl
@onready var language_selector: OptionButton = $Panel/HBoxContainer/LanguageSelector
@onready var back_button: Button = $Panel/BackMenu

func _ready() -> void:
	# Загружаем текущие значения из синглтона Settings
	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sfx_slider.value = Settings.sfx_volume
	fullscreen_toggle.button_pressed = Settings.fullscreen
	
	# Устанавливаем язык в селекторе
	match Settings.language:
		"ru":
			language_selector.select(0)
		"en":
			language_selector.select(1)
	
	# Подключаем сигналы
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	language_selector.item_selected.connect(_on_language_selected)
	back_button.pressed.connect(_on_back_pressed)

func _on_master_changed(value: float) -> void:
	Settings.set_master_volume(value)

func _on_music_changed(value: float) -> void:
	Settings.set_music_volume(value)

func _on_sfx_changed(value: float) -> void:
	Settings.set_sfx_volume(value)

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	Settings.set_fullscreen(toggled_on)

func _on_language_selected(index: int) -> void:
	match index:
		0:
			Settings.set_language("ru")
		1:
			Settings.set_language("en")

func _on_back_pressed() -> void:
	queue_free() # Удаляем сцену настроек
