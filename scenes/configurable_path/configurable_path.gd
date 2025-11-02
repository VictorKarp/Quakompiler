extends LineEdit

@export var config_key: String


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	text_changed.connect(_on_text_changed)


func _on_config_loaded() -> void:
	text = Config.get_game_value(config_key)
	caret_column = text.length()


func _on_text_changed(new_text: String) -> void:
	Config.set_game_value(config_key, new_text)
