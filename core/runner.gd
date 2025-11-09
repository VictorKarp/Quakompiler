extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		run_game()


func run_game() -> void:
	var commands = get_run_commands_array()
	OS.create_process(commands[0], commands[1])


func get_run_commands_array() -> Array:
	var game_path: String = Config.get_game_value("game_path")
	var map: String = Config.get_game_value("map_path").get_file().rstrip(".map")
	var basedir: String = Config.get_game_value("game_path").get_base_dir()
	var mod: String = Config.get_game_value("mod")
	match Config.get_current_game():
		Enums.game.QUAKE1:
			return[game_path, ["-basedir", basedir, "+game", mod, "+map", map]]
		Enums.game.QUAKE3:
			if OS.get_name() == "Windows":
				return["cmd.exe", ["/C", "cd /d " + basedir + " && " + game_path + " +sv_pure 0 +devmap " + map]]
			else:
				return[game_path, ["+set fs_game " + mod + " +sv_pure 0 +devmap " + map]]
		_:
			return []


func get_run_commands() -> String:
	var commands = get_run_commands_array()
	var line = commands[0] + " "
	for item in commands[1]:
		line += item + " "
	line = line.rstrip(" ")
	line = line.replace("  ", " ")
	return line
