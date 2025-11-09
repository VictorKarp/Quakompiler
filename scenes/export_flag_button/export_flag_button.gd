extends Button

enum Action {
	BSP = 0,
	VIS = 1,
	LIGHT = 2,
	BSPC = 3,
	PAUSE = 4,
	RUN = 5,
}

@export var game: Enums.game
@export var action: Action


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _toggled(toggled_on: bool) -> void:
	var key = _get_config_string()
	Config.set_game_value(key, toggled_on)


func _get_config_string() -> String:
	return "export_" + Action.keys()[action].to_lower()


func _on_config_loaded() -> void:
	var key = _get_config_string()
	var value = Config.get_game_value(key, game)
	if value:
		set_pressed_no_signal(value)
