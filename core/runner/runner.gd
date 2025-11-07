extends Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		run_game()


func run_game() -> void:
	var game_path: String = Config.get_game_value("game_path")
	var map: String = Config.get_game_value("map_path").get_file().rstrip(".map")
	var basedir: String = Config.get_game_value("game_path").get_base_dir()
	var mod: String = Config.get_game_value("mod")
	match Config.current_game:
		Enums.game.QUAKE1:
			OS.create_process(game_path, ["-basedir", basedir, "+game", mod, "+map", map])
		Enums.game.QUAKE3:
			OS.create_process("cmd.exe", ["/C", "cd /d " + basedir + " && " + game_path + " +sv_pure 0 +devmap " + map])
