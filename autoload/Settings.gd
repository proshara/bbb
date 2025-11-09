extends Node

const SAVE_FILE_PATH = "user://settings.json"

var policy_accepted: bool = false
var master_volume: float = 0.0
var music_volume: float = 0.0
var sfx_volume: float = 0.0
var fullscreen: bool = false
var language: String = "ru"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()
	apply_settings()
	
func save_settings():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	if not file:
		print("Не удалось открыть файл для записи")
		return
	
	var data = {
		"policy_accepted": policy_accepted,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"fullscreen": fullscreen,
		"language": language
	}
	
	file.store_var(data)
	file.close()

func load_settings():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		policy_accepted = data.get("policy_accepted", false)
		master_volume = data.get("master_volume", 0.0)
		music_volume = data.get("music_volume", 0.0)
		sfx_volume = data.get("sfx_volume", 0.0)
		fullscreen = data.get("fullscreen", false)
		language = data.get("language", "ru")
	else:
		save_settings()

func apply_settings():
	var bus_master = AudioServer.get_bus_index("Master")
	var bus_music = AudioServer.get_bus_index("Music")
	var sfx_music = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_master, master_volume)
	AudioServer.set_bus_volume_db(bus_music, music_volume)
	AudioServer.set_bus_volume_db(sfx_music, sfx_volume)
	
	TranslationServer.set_locale(language)
	
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
