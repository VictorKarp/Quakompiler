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
	elif (
			event.is_action_pressed("compile_bspc")
			and Config.get_current_game() == Enums.game.QUAKE3
			and not event.alt_pressed
		):
		# Checking if Alt is pressed prevents running this code if the user
		# quits the application by pressing Alt+F4.
		compile_bspc(Enums.compile_mode.SINGLE)
	elif event.is_action_pressed("compile_selected"):
		compile_selected()


func compile_bsp(compile_mode: Enums.compile_mode):
	var commands: Array = get_bsp_commands()
	_run_compiler(commands[0], commands[1], compile_mode)


func get_bsp_commands() -> Array:
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

	return [compiler_path, args]


func compile_vis(compile_mode: Enums.compile_mode):
	var commands = get_vis_commands()
	_run_compiler(commands[0], commands[1], compile_mode)


func get_vis_commands() -> Array:
	var compiler_path: String
	var base_path = Config.get_game_value("game_path").get_base_dir()
	var args := ""
	var switches: String = Config.get_game_value("vis_switches")
	var output_path: String = Config.get_output_path()

	match Config.get_current_game():
		Enums.game.QUAKE1:
			compiler_path = Config.get_game_value("vis_path")
			args = switches + " " + output_path
		Enums.game.QUAKE3:
			compiler_path = Config.get_game_value("q3map2_path")
			args = "-fs_basepath " + base_path + " -vis " + switches + " " + output_path

	return [compiler_path, args]


func compile_light(compile_mode: Enums.compile_mode):
	var commands = get_light_commands()
	_run_compiler(commands[0], commands[1], compile_mode)


func get_light_commands() -> Array:
	var compiler_path: String
	var base_path = Config.get_game_value("game_path").get_base_dir()
	var args := ""
	var switches: String = Config.get_game_value("light_switches")
	var map_path: String = Config.get_game_value("map_path")
	var output_path: String = Config.get_output_path()

	match Config.get_current_game():
		Enums.game.QUAKE1:
			compiler_path = Config.get_game_value("light_path")
			args = switches + " " + output_path
		Enums.game.QUAKE3:
			compiler_path = Config.get_game_value("q3map2_path")
			args = "-fs_basepath " + base_path + " -light " + switches + " " + map_path

	return [compiler_path, args]


func compile_bspc(compile_mode: Enums.compile_mode):
	var commands = get_bspc_commands()
	_run_compiler(commands[0], commands[1], compile_mode)


func get_bspc_commands() -> Array:
	var compiler_path: String = Config.get_game_value("bspc_path")
	var switches: String = Config.get_game_value("bspc_switches")
	var output_path: String = Config.get_output_path()
	var args = switches + " " + output_path
	return [compiler_path, args]


func _run_compiler(compiler_path, args, compile_mode: Enums.compile_mode) -> void:
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
		_compiler_pid = OS.create_process(selected_terminal, ["--", "bash", "-c", compiler_path + " " + args])
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
	if Config.get_current_game() == Enums.game.QUAKE3:
		if OS.get_name() == "Windows":
			_is_compiling_batch = OS.is_process_running(_compiler_pid)
		elif OS.get_name() == "Linux":
			# q3maps2 can spawn new subprocesses during compilation, which
			# makes process detection via PID fail on Linux. So we check
			# for running processes with the compiler's file name instead.
			var compiler = Config.get_game_value("q3map2_path").get_file()
			var exit_code = OS.execute("pgrep", [compiler], [], true)
			_is_compiling_batch = exit_code == 0
	else:
		_is_compiling_batch = OS.is_process_running(_compiler_pid)
	if not _is_compiling_batch:
		%CompilerRunCheck.stop()
		_start_next_queued_action()
