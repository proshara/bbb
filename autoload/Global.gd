extends Node

const SAVE_PATH := "user://savegame.json"
var gold = 0
var gold_minus = 100

func save_game() -> void:
	var data = {'gold': gold, 'gold_minus': gold_minus}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()
		print("Игра сохранена:", data)
	else:
		print("Не удалось открыть файл для записи!")

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("Сохранения не найдены")
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var json = JSON.parse_string(content)
		if typeof(json) == TYPE_DICTIONARY:
			gold = json.get('gold', 0)
			gold_minus = json.get('gold_minus', 100)
			print("Загружено:", json)
		else:
			print("Ошибка чтения JSON.")
	else:
		print("Не удалось открыть файл для чтения!")
		
func has_valid_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return file
	
	var content = file.get_as_text()
	file.close()
	var json = JSON.parse_string(content)
	return typeof(json) == TYPE_DICTIONARY and json.get('gold', 0) > 0 and json.get('gold_minus', 100) < 100
