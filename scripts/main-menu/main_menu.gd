extends Control

@onready var main_menu_button: VBoxContainer = $Panel/MainMenuButton
@onready var choice_game: Panel = $Panel/ChoiceGame
@onready var continue_game: Button = $Panel/ChoiceGame/HBoxContainer/ContinueGame
@onready var editor_player: Panel = $Panel/EditorPlayer
@onready var privacy_policy: Control = $PrivacyPolicy

var settings_scene = preload("res://scenes/settings-menu/settingsMenu.tscn")
var settings_instance = null

# Создаём overlay для затемнения
var overlay: ColorRect

func _ready() -> void:
	main_menu_button.visible = false
	choice_game.visible = false
	editor_player.visible = false
	privacy_policy.visible = true
	continue_game.disabled = not Global.has_valid_save()

func _input(event: InputEvent) -> void:
	# ESC для закрытия настроек
	if event.is_action_pressed("ui_cancel") and settings_instance:
		_close_settings()

func _on_start_pressed() -> void:
	main_menu_button.visible = false
	choice_game.visible = true

func _on_settings_pressed() -> void:
	main_menu_button.visible = false
	#overlay.visible = true
	
	settings_instance = settings_scene.instantiate()
	add_child(settings_instance)

func _close_settings() -> void:
	if settings_instance:
		settings_instance.queue_free()
		settings_instance = null
	
	overlay.visible = false
	main_menu_button.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_menu_pressed() -> void:
	if settings_instance:
		_close_settings()
	else:
		main_menu_button.visible = true
		choice_game.visible = false

func _on_new_game_pressed() -> void:
	Global.gold = 0
	Global.gold_minus = 100
	Global.save_game()
	choice_game.visible = false
	editor_player.visible = true

func _on_continue_game_pressed() -> void:
	Global.load_game()
	get_tree().change_scene_to_file("res://scenes/main-menu-level/levelTest.tscn")

func _on_start_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main-menu-level/levelTest.tscn")
	
func _on_back_to_load_pressed() -> void:
	editor_player.visible = false
	choice_game.visible = true

func _on_accept_privacy_pressed() -> void:
	Settings.policy_accepted = true
	Settings.save_settings()
	main_menu_button.visible = true
	privacy_policy.visible = false
