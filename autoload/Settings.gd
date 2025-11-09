extends Node

const SAVE_FILE_PATH = "user://settings.json"

# Настройки по умолчанию
var policy_accepted: bool = false
var master_volume: float = 0.5
var music_volume: float = 1.0
var sfx_volume: float = 0.5
var fullscreen: bool = false
var language: String = "ru"

func _ready() -> void:
	print("=== Settings._ready() вызван ===")
	print("Путь к файлу: ", ProjectSettings.globalize_path(SAVE_FILE_PATH))
	load_settings()
	apply_settings()
	print("Текущие настройки после загрузки:")
	print("  master_volume: ", master_volume)
	print("  music_volume: ", music_volume)
	print("  sfx_volume: ", sfx_volume)
	print("  fullscreen: ", fullscreen)
	print("  language: ", language)

func save_settings() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	
	if not file:
		push_error("Не удалось открыть файл для записи настроек")
		return
	
	var data = {
		"policy_accepted": policy_accepted,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"fullscreen": fullscreen,
		"language": language
	}
	
	file.store_string(JSON.stringify(data))
	file.close()
	print("Настройки сохранены:", data)

func load_settings() -> void:
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		print("Файл настроек не найден, создаём новый")
		save_settings()
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if not file:
		push_error("Не удалось открыть файл настроек для чтения")
		save_settings() # Пересоздаём файл
		return
	
	var content = file.get_as_text()
	file.close()
	
	# Проверка на пустой файл
	if content.strip_edges().is_empty():
		print("Файл настроек пустой, создаём новый")
		save_settings()
		return
	
	var json = JSON.parse_string(content)
	if typeof(json) != TYPE_DICTIONARY:
		push_error("Повреждённый JSON в настройках. Пересоздаём файл.")
		save_settings() # Пересоздаём файл с дефолтными настройками
		return
	
	policy_accepted = json.get("policy_accepted", false)
	master_volume = json.get("master_volume", 0.5)
	music_volume = json.get("music_volume", 1.0)
	sfx_volume = json.get("sfx_volume", 0.5)
	fullscreen = json.get("fullscreen", false)
	language = json.get("language", "ru")
	
	print("Настройки загружены:", json)

func apply_settings() -> void:
	# Применяем громкость
	_set_bus_volume("Master", master_volume)
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)
	
	# Применяем язык
	TranslationServer.set_locale(language)
	
	# Применяем полноэкранный режим
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _set_bus_volume(bus_name: String, linear_value: float) -> void:
	var bus_id = AudioServer.get_bus_index(bus_name)
	if bus_id == -1:
		push_error("Аудио шина не найдена: " + bus_name)
		return
	AudioServer.set_bus_volume_db(bus_id, linear_to_db(linear_value))

# Удобные методы для UI
func set_master_volume(value: float) -> void:
	master_volume = value
	_set_bus_volume("Master", value)
	save_settings()

func set_music_volume(value: float) -> void:
	music_volume = value
	_set_bus_volume("Music", value)
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = value
	_set_bus_volume("SFX", value)
	save_settings()

func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func set_language(lang: String) -> void:
	language = lang
	TranslationServer.set_locale(lang)
	save_settings()
