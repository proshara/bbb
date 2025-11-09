extends Control

var settings_scene = preload("res://scenes/settings-menu/settingsMenu.tscn")
var settings_instance = settings_scene.instantiate()

@onready var pause_menu: Control = $PauseMenu
@onready var labelCounter: Label = $Panel/Label
@onready var labelCounterMinus: Label = $Panel/Label2

var is_paused: bool = false

func _ready() -> void:
	Global.load_game()
	Global.gold = Global.gold
	labelCounter.text = str(Global.gold)
	labelCounterMinus.text = str(Global.gold_minus)
	pause_menu.visible = false

func toggle_pause():
	pause_menu.visible = is_paused
	get_tree().paused = is_paused
	
func _on_button_pressed() -> void:
	Global.gold += 1
	Global.gold_minus -= 1
	labelCounter.text = str(Global.gold)
	labelCounterMinus.text = str(Global.gold_minus)
	Global.gold = Global.gold
	Global.gold_minus = Global.gold_minus
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		pause_menu.visible = true

func _on_continue_pressed():
	toggle_pause()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main-menu/main_menu.tscn")
	Global.save_game()	

func _on_settings_pressed() -> void:
	pause_menu.visible = false
	add_child(settings_instance)

func _on_back_menu_pressed() -> void:
	pause_menu.visible = true
	remove_child(settings_instance)

func _on_save_game_pressed() -> void:
	Global.save_game()
	print('Игра сохранена')
