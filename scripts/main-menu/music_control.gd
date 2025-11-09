extends HSlider

@export var audio_bus_name: String
var audio_bus_id

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	
func _on_value_changed(music_value: float) -> void: #	Можно передавать value, но будет предупреждение. Можно ли его игнорировать?
	var db = linear_to_db(music_value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)
