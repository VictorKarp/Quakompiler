class_name Main
extends Control


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	# Compiling
	var bsp_single = Compiler.compile_bsp.bind(Enums.compile_mode.SINGLE)
	var vis_single = Compiler.compile_vis.bind(Enums.compile_mode.SINGLE)
	var light_single = Compiler.compile_light.bind(Enums.compile_mode.SINGLE)
	%CompileBsp.pressed.connect(bsp_single)
	%CompileVis.pressed.connect(vis_single)
	%CompileLight.pressed.connect(light_single)
	%CompileSelected.pressed.connect(Compiler.compile_selected)

	# Running
	%RunGame.pressed.connect(run_game)

	# Window size
	DisplayServer.window_set_min_size(Vector2i(420, 120))

	# Config
	Config.load_config()


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


func _on_config_loaded() -> void:
	var window_size = Config.get_global_value("window_size")
	if window_size:
		DisplayServer.window_set_size(window_size)

	var window_position = Config.get_global_value("window_position")
	if window_position:
		DisplayServer.window_set_position(window_position)


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
