extends Node

var _compiler_pid: int
var _is_compiling_single := false
var _is_compiling_batch := false
var _compilation_queue: Array[String]


func _ready() -> void:
	%CompilerRunCheck.timeout.connect(_on_compiler_run_check_timeout)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("compile_bsp"):
		compile_bsp(Enums.compile_mode.SINGLE)
	elif event.is_action_pressed("compile_vis"):
		compile_vis(Enums.compile_mode.SINGLE)
	elif event.is_action_pressed("compile_light"):
		compile_light(Enums.compile_mode.SINGLE)
	elif event.is_action_pressed("compile_selected") and not event.alt_pressed:
		# Checking if Alt is pressed prevents running this code if the user
		# quits the application by pressing Alt+F4.
		compile_selected()


func compile_bsp(compile_mode: Enums.compile_mode):
	var compiler_path: String
	var base_path = Config.get_game_value("game_path").get_base_dir()
	var map_path: String = Config.get_game_value("map_path")
	var output_path: String = Config.get_output_path()
	var switches: String = Config.get_game_value("bsp_switches")
	var args: String
	match Config.get_current_game():
		Enums.game.QUAKE1:
			compiler_path = Config.get_game_value("bsp_path")
			args = switches + " " + map_path + " " + output_path
		Enums.game.QUAKE3:
			compiler_path = Config.get_game_value("q3map2_path")
			args = "-fs_basepath " + base_path + " " + switches + " " + map_path
	_run_compiler(compiler_path, args, compile_mode)


func compile_vis(compile_mode: Enums.compile_mode):
	var compiler_path: String
	var base_path = Config.get_game_value("game_path").get_base_dir()
	var args: String
	match Config.get_current_game():
		Enums.game.QUAKE1:
			compiler_path = Config.get_game_value("vis_path")
		Enums.game.QUAKE3:
			compiler_path = Config.get_game_value("q3map2_path")
			args = "-fs_basepath " + base_path + " -vis"
	var switches: String = Config.get_game_value("vis_switches")
	var output_path: String = Config.get_output_path()
	if switches:
		args += " " + switches
	args += " " + output_path
	_run_compiler(compiler_path, args, compile_mode)


func compile_light(compile_mode: Enums.compile_mode):
	var compiler_path: String
	var base_path = Config.get_game_value("game_path").get_base_dir()
	var args := ""
	var switches: String = Config.get_game_value("light_switches")
	var map_path: String = Config.get_game_value("map_path")
	var output_path: String = Config.get_output_path()

	match Config.get_current_game():
		Enums.game.QUAKE1:
			compiler_path = Config.get_game_value("light_path")
			if switches:
				args = switches
			args += " " + output_path
		Enums.game.QUAKE3:
			compiler_path = Config.get_game_value("q3map2_path")
			args = "-fs_basepath " + base_path + " -light"
			if switches:
				args += " " + switches
			args += " " + map_path

	_run_compiler(compiler_path, args, compile_mode)


func compile_bspc(compile_mode: Enums.compile_mode):
	var compiler_path: String = Config.get_game_value("bspc_path")
	var switches: String = Config.get_game_value("bspc_switches")
	var output_path: String = Config.get_output_path()
	var args := ""
	if switches:
		args += " " + switches
	args += " " + output_path
	_run_compiler(compiler_path, args, compile_mode)


func _run_compiler(compiler_path, args, compile_mode: Enums.compile_mode) -> void:
	print(compiler_path)
	print(args)
	# Pausing after compilation
	var pause := false
	match compile_mode:
		Enums.compile_mode.SINGLE:
			if Config.get_game_value("pause_after_single"):
				pause = true
			_is_compiling_single = true
		Enums.compile_mode.BATCH:
			if Config.get_game_value("pause_after_batch"):
				pause = true
			_is_compiling_batch = true
			%CompilerRunCheck.start()
	if pause:
		if OS.get_name() == "Windows":
			args += "&& pause"
		elif OS.get_name() == "Linux":
			args += "; read"

	if OS.get_name() == "Linux":
		var terminals: Array[String] = ["gnome-terminal", "xfce4-terminal", "konsole",
				"guake", "yakuake", "terminator", "tilix", "kitty", "xterm"]
		var selected_terminal: String
		for terminal in terminals:
			var exit_code = OS.execute("command", ["-v", terminal], [], true, false)
			if exit_code == 0:
				selected_terminal = terminal
				break
		_compiler_pid = OS.create_process(selected_terminal, ["--", "bash", "-c", compiler_path, args])
	else:
		_compiler_pid = OS.create_process("cmd.exe", ["/c", compiler_path + " " + args], true)


func compile_selected() -> void:
	_cancel_compilation()
	if Config.get_game_value("bsp_enabled"):
		_compilation_queue.append("bsp")
	if Config.get_game_value("vis_enabled"):
		_compilation_queue.append("vis")
	if Config.get_game_value("light_enabled"):
		_compilation_queue.append("light")
	if Config.get_game_value("bspc_enabled"):
		_compilation_queue.append("bspc")
	_start_next_queued_action()


func _cancel_compilation() -> void:
	if _is_compiling_single or _is_compiling_batch:
		OS.kill(_compiler_pid)
	_compilation_queue.clear()


func _start_next_queued_action() -> void:
	var next_action = _compilation_queue.pop_front()
	match next_action:
		"bsp":
			compile_bsp(Enums.compile_mode.BATCH)
		"vis":
			compile_vis(Enums.compile_mode.BATCH)
		"light":
			compile_light(Enums.compile_mode.BATCH)
		"bspc":
			compile_bspc(Enums.compile_mode.BATCH)
		_:
			if Config.get_game_value("launch_after_compile"):
				Runner.run_game()


func _on_compiler_run_check_timeout() -> void:
	_is_compiling_batch = OS.is_process_running(_compiler_pid)
	if not _is_compiling_batch:
		%CompilerRunCheck.stop()
		_start_next_queued_action()
