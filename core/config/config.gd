extends Node

signal config_value_changed(game: String, key: String, value)

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
	"pause_after_single" = false,
	"pause_after_batch" = false,
}

var _is_loading_config := false


func save_config() -> void:
	if _is_loading_config:
		return

	var config := ConfigFile.new()
	for key in config_q1:
		config.set_value("q1", key, config_q1[key])

	config.save("config.ini")


func load_config() -> void:
	var config = ConfigFile.new()
	var error = config.load("config.ini")
	if error != OK:
		return

	_is_loading_config = true
	for section in config.get_sections():
		for key in config.get_section_keys(section):
			var value = config.get_value(section, key)
			set_config_value(section, key, value)
	_is_loading_config = false


func set_config_value(game: String, key: String, value) -> void:
	match game:
		"q1":
			config_q1.set(key, value)
		_:
			return
	config_value_changed.emit(game, key, value)
	save_config()


func get_config_value(game: String, key: String):
	match game:
		"q1":
			return config_q1.get(key)
		_:
			return null


func get_output_path(game: String) -> String:
	var output_path = get_config_value(game, "output_path")
	var map_name = get_config_value(game, "map_path").get_file().rstrip(".map")
	return output_path + "/" + map_name + ".bsp"


func _get_bsp_switches_array(game: String) -> PackedStringArray:
	match game:
		"q1":
			return config_q1["bsp_switches".split(" ", false)]
		_:
			return []


func _get_bsp_switches_text(game: String) -> PackedStringArray:
	match game:
		"q1":
			return config_q1["vis_switches".split(" ", false)]
		_:
			return []
