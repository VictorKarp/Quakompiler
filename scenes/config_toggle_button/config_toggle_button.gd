extends Button

@export var config_key: String


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Config.set_game_value(config_key, button_pressed)


func _on_config_loaded() -> void:
	var value = Config.get_game_value(config_key)
	if value:
		set_pressed_no_signal(value)
