extends Control

var settings_scene = preload("res://scenes/settings-menu/settingsMenu.tscn")
var settings_instance = null

@onready var pause_menu: Control = $PauseMenu
@onready var labelCounter: Label = $Panel/Label
@onready var labelCounterMinus: Label = $Panel/Label2

# Создаём overlay для затемнения
var overlay: ColorRect

var is_paused: bool = false

func _ready() -> void:
	Global.load_game()
	labelCounter.text = str(Global.gold)
	labelCounterMinus.text = str(Global.gold_minus)
	pause_menu.visible = false
	
	# Создаём затемняющий оверлей
	overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.7) # Чёрный с прозрачностью 70%
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.visible = false
	add_child(overlay)

func toggle_pause():
	is_paused = !is_paused
	pause_menu.visible = is_paused
	overlay.visible = is_paused
	get_tree().paused = is_paused
	
func _on_button_pressed() -> void:
	Global.gold += 1
	Global.gold_minus -= 1
	labelCounter.text = str(Global.gold)
	labelCounterMinus.text = str(Global.gold_minus)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Если открыты настройки - закрываем их
		if settings_instance:
			_close_settings()
		else:
			toggle_pause()

func _on_continue_pressed():
	toggle_pause()

func _on_quit_pressed() -> void:
	Global.save_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main-menu/mainMenu.tscn")

func _on_settings_pressed() -> void:
	pause_menu.visible = false
	
	# Создаём новый экземпляр настроек
	settings_instance = settings_scene.instantiate()
	add_child(settings_instance)
	
	# Показываем затемнение
	overlay.visible = true

func _close_settings() -> void:
	if settings_instance:
		settings_instance.queue_free()
		settings_instance = null
	
	# Возвращаемся к меню паузы
	pause_menu.visible = true
	overlay.visible = true

func _on_save_game_pressed() -> void:
	Global.save_game()
	print('Игра сохранена')
