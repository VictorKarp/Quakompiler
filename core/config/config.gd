extends Node

signal config_loaded

var current_game := Enums.game.QUAKE1

var config := {
	global = {
		"window_size" = Vector2i(1152,648),
		"window_position" = Vector2i.ZERO
	},
	q1 = {
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
	},
	q3 = {
		"q3map2_path" = "",
		"bspc_path" = "",
		"game_path" = "",
		"map_path" = "",
		"output_path" = "",
		"bsp_switches" = "",
		"vis_switches" = "",
		"light_switches" = "",
		"bspc_switches" = "",
		"mod" = "",
		"bsp_enabled" = false,
		"vis_enabled" = false,
		"light_enabled" = false,
		"bspc_enabled" = false,
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
}

var _is_loading_config := false


func _ready() -> void:
	DisplayServer.window_set_min_size(Vector2i(420, 120))
	_load_config()
	_restore_window_size_and_pos()


func _exit_tree() -> void:
	config["global"].set("window_size", DisplayServer.window_get_size())
	config["global"].set("window_position", DisplayServer.window_get_position())
	save_config()


func save_config() -> void:
	if _is_loading_config:
		return

	var config_file := ConfigFile.new()
	for section in config:
		for key in config[section]:
			var value = config[section][key]
			config_file.set_value(section, key, value)

	config_file.save("config.ini")


func _load_config() -> void:
	var config_file = ConfigFile.new()
	var error = config_file.load("config.ini")
	if error != OK:
		return

	_is_loading_config = true
	for section in config_file.get_sections():
		for key in config_file.get_section_keys(section):
			var value = config_file.get_value(section, key)
			config[section][key] = value
			#if section == "global":
				#set_global_value(key, value)
			#else:
				#set_game_value(key, value)
	_is_loading_config = false
	config_loaded.emit()


func set_game_value(key: String, value, game := current_game) -> void:
	match game:
		Enums.game.QUAKE1:
			config["q1"][key] = value
		Enums.game.QUAKE3:
			config["q3"][key] = value


func set_global_value(key: String, value) -> void:
	config["global"][key] = value


func get_global_value(key: String):
	return config["global"][key]


func get_game_value(key: String, game := current_game):
	var value = null
	match game:
		Enums.game.QUAKE1:
			if config.has("q1"):
				if config["q1"].has(key):
					value = config["q1"][key]
		Enums.game.QUAKE3:
			if config.has("q3"):
				if config["q3"].has(key):
					value = config["q3"][key]
		_:
			pass
	return value


func get_output_path() -> String:
	var output_path = get_game_value("output_path")
	var map_name = get_game_value("map_path").get_file().rstrip(".map")
	return output_path + "/" + map_name + ".bsp"


func _restore_window_size_and_pos() -> void:
	var window_size = config["global"]["window_size"]
	if window_size:
		DisplayServer.window_set_size(window_size)

	var window_position = config["global"]["window_position"]
	if window_position:
		DisplayServer.window_set_position(window_position)
