extends Node


func run_game() -> void:
	var game_path: String = Config.get_game_value("game_path")
	var map: String = Config.get_game_value("map_path").get_file().rstrip(".map")
	var basedir: String = Config.get_game_value("game_path").get_base_dir()
	var mod: String = Config.get_game_value("mod")
	OS.create_process(game_path, ["-basedir", basedir, "+game", mod, "+map", map])
