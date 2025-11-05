extends Node

signal config_loaded

var current_game := Enums.game.QUAKE1

var config_q1 := {
	"bsp_path" = "",
	"vis_path" = "",
	"light_path" = "",
	"game_path" = "",
	"map_path" = "",
	"output_path" = "",
	"bsp_switches" = "",
	"vis_switches" = "",
	"light_switches" = "",
	"mod" = "",
	"bsp_enabled" = false,
	"vis_enabled" = false,
	"light_enabled" = false,
	"launch_after_compile" = false,
	"compilers_folded" = false,
	"switches_folded" = false,
	"game_folded" = false,
	"pause_after_single" = false,
	"pause_after_batch" = false,
	"single_folded" = false,
	"batch_folded" = false,
	"run_folded" = false,
	"hotkeys_folded" = false,
}

var config_global := {
	"window_size" = Vector2i(1152,648),
	"window_position" = Vector2i.ZERO
}

var _is_loading_config := false


func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(420, 120))
	_load_config()
	_restore_window_size_and_pos()


func _exit_tree() -> void:
	config_global.set("window_size", DisplayServer.window_get_size())
	config_global.set("window_position", DisplayServer.window_get_position())
	save_config()


func save_config() -> void:
	if _is_loading_config:
		return

	var config := ConfigFile.new()
	for key in config_global:
		config.set_value("global", key, config_global[key])
	for key in config_q1:
		config.set_value("q1", key, config_q1[key])

	config.save("config.ini")


func _load_config() -> void:
	var config = ConfigFile.new()
	var error = config.load("config.ini")
	if error != OK:
		return

	_is_loading_config = true
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			var value = config.get_value(section, key)
			if section == "global":
				set_global_value(key, value)
			else:
				set_game_value(key, value)
	_is_loading_config = false
	config_loaded.emit()


func set_game_value(key: String, value) -> void:
	match current_game:
		Enums.game.QUAKE1:
			prints(key, value)
			config_q1.set(key, value)


func set_global_value(key: String, value) -> void:
	config_global.set(key, value)


func get_global_value(key: String):
	return config_global.get(key)


func get_game_value(key: String, game := current_game):
	match current_game:
		Enums.game.QUAKE1:
			return config_q1.get(key)
		_:
			return null


func get_output_path() -> String:
	var output_path = get_game_value("output_path")
	var map_name = get_game_value("map_path").get_file().rstrip(".map")
	return output_path + "/" + map_name + ".bsp"


func _get_bsp_switches_array(game: Enums.game) -> PackedStringArray:
	match game:
		Enums.game.QUAKE1:
			return config_q1["bsp_switches".split(" ", false)]
		_:
			return []


func _get_bsp_switches_text(game: Enums.game) -> PackedStringArray:
	match game:
		Enums.game.QUAKE1:
			return config_q1["vis_switches".split(" ", false)]
		_:
			return []


func _restore_window_size_and_pos() -> void:
	var window_size = config_global.get("window_size")
	if window_size:
		DisplayServer.window_set_size(window_size)

	var window_position = config_global.get("window_position")
	if window_position:
		DisplayServer.window_set_position(window_position)
