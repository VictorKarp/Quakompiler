class_name Main
extends Control


func _ready() -> void:
	# Running
	%RunGame.pressed.connect(run_game)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("compile_bsp"):
		Compiler.compile_bsp(Enums.compile_mode.SINGLE)
	if event.is_action_pressed("compile_vis"):
		Compiler.compile_vis(Enums.compile_mode.SINGLE)
	if event.is_action_pressed("compile_light"):
		Compiler.compile_light(Enums.compile_mode.SINGLE)
	if event.is_action_pressed("compile_selected"):
		Compiler.compile_selected()
	if event.is_action_pressed("run"):
		run_game()


func run_game() -> void:
	var game_path: String = Config.get_game_value("game_path")
	var map: String = Config.get_game_value("map_path").get_file().rstrip(".map")
	var basedir: String = Config.get_game_value("game_path").get_base_dir()
	var mod: String = Config.get_game_value("mod")
	OS.create_process(game_path, ["-basedir", basedir, "+game", mod, "+map", map])


func _on_pause_after_single_toggled(value: bool) -> void:
	Config.set_game_value("pause_after_single", value)


func _on_pause_after_batch_toggled(value: bool) -> void:
	Config.set_game_value("pause_after_batch", value)
