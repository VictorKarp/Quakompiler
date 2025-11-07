extends Node

signal config_loaded


var config := {
	application = {
		"window_size" = Vector2i(1152,648),
		"window_position" = Vector2i.ZERO,
		"q1_scroll" = 0,
		"q3_scroll" = 0,
		"current_game" = Enums.game.QUAKE1,
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


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		config["application"].set("window_size", DisplayServer.window_get_size())
		config["application"].set("window_position", DisplayServer.window_get_position())
		config["application"].set("q1_scroll", get_tree().get_first_node_in_group("q1_scroll").scroll_vertical)
		config["application"].set("q3_scroll", get_tree().get_first_node_in_group("q3_scroll").scroll_vertical)
		save_config()
		get_tree().quit()


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
	_is_loading_config = false
	config_loaded.emit()


func set_game_value(key: String, value, game := get_current_game()) -> void:
	match game:
		Enums.game.QUAKE1:
			config["q1"][key] = value
		Enums.game.QUAKE3:
			config["q3"][key] = value


func set_application_value(key: String, value) -> void:
	config["application"][key] = value


func get_application_value(key: String):
	return config["application"][key]


func get_current_game() -> Enums.game:
	return config["application"]["current_game"]


func set_current_game(value: Enums.game) -> void:
	config["application"]["current_game"] = value


func get_game_value(key: String, game := get_current_game()):
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

	if not DirAccess.dir_exists_absolute(output_path) or output_path == "":
		output_path = get_game_value("map_path").get_base_dir()

	return output_path + "/" + map_name + ".bsp"


func _restore_window_size_and_pos() -> void:
	var window_size = config["application"]["window_size"]
	if window_size:
		DisplayServer.window_set_size(window_size)

	var window_position = config["application"]["window_position"]
	if window_position:
		DisplayServer.window_set_position(window_position)
