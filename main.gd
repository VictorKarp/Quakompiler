extends Control

var _compiler_pid: int
var _is_compiling := false
var _compilation_queue: Array[String]


func _init() -> void:
	Config.config_value_changed.connect(_on_config_value_changed)


func _ready() -> void:
	# File browsers
	%SelectBspPath.pressed.connect(_show_bsp_browser)
	%SelectVisPath.pressed.connect(_show_vis_browser)
	%SelectLightPath.pressed.connect(_show_light_browser)
	%SelectMapPath.pressed.connect(_show_map_browser)
	%SelectOutputFolder.pressed.connect(_show_output_browser)
	%SelectGamePath.pressed.connect(_show_game_browser)

	# Paths
	%BspPath.text_changed.connect(_set_bsp_path)
	%VisPath.text_changed.connect(_set_vis_path)
	%LightPath.text_changed.connect(_set_light_path)
	%MapPath.text_changed.connect(_set_map_path)
	%OutputPath.text_changed.connect(_set_output_path)
	%GamePath.text_changed.connect(_set_game_path)
	%Mod.text_changed.connect(_set_mod)

	# Switches
	%BspEnabled.toggled.connect(_on_bsp_enabled)
	%VisEnabled.toggled.connect(_on_vis_enabled)
	%LightEnabled.toggled.connect(_on_light_enabled)

	# Switch values
	%BspSwitches.text_changed.connect(_set_bsp_switches)
	%VisSwitches.text_changed.connect(_set_vis_switches)
	%LightSwitches.text_changed.connect(_set_light_switches)

	# Dialogues
	%SelectBspDialog.file_selected.connect(_set_bsp_path)
	%SelectVisDialog.file_selected.connect(_set_vis_path)
	%SelectLightDialog.file_selected.connect(_set_light_path)
	%SelectMapDialog.file_selected.connect(_set_map_path)
	%SelectOutputDialog.dir_selected.connect(_set_output_path)
	%SelectGameDialog.file_selected.connect(_set_game_path)

	# Compiling
	%CompileBsp.pressed.connect(_compile_bsp)
	%CompileVis.pressed.connect(_compile_vis)
	%CompileLight.pressed.connect(_compile_light)
	%CompileSelected.pressed.connect(_compile_selected)

	# Running
	%LaunchAfterCompile.toggled.connect(_on_launch_after_compile_toggled)
	%RunGame.pressed.connect(_run_game)

	# Help
	%BspHelp.pressed.connect(_print_bsp_help)
	%VisHelp.pressed.connect(_print_vis_help)
	%LightHelp.pressed.connect(_print_light_help)
	%CloseHelp.pressed.connect(_close_help)

	# Console
	%ClearConsole.pressed.connect(_clear_help)

	# Timers
	%CompilerRunCheck.timeout.connect(_on_compiler_run_check_timeout)

	Config.load_config()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("compile_bsp"):
		_compile_bsp()
	if event.is_action_pressed("compile_vis"):
		_compile_vis()
	if event.is_action_pressed("compile_light"):
		_compile_light()
	if event.is_action_pressed("compile_selected"):
		_compile_selected()
	if event.is_action_pressed("clear_console"):
		_clear_help()
	if event.is_action_pressed("run"):
		_run_game()


func _on_config_value_changed(game, key, value) -> void:
	match game:
		"q1":
			match key:
				"bsp_path":
					%BspPath.text = value
					%BspPath.caret_column = %BspPath.text.length()
				"vis_path":
					%VisPath.text = value
					%VisPath.caret_column = %VisPath.text.length()
				"light_path":
					%LightPath.text = value
					%LightPath.caret_column = %LightPath.text.length()
				"bsp_switches":
					%BspSwitches.text = value
					%BspSwitches.caret_column = %BspSwitches.text.length()
				"vis_switches":
					%VisSwitches.text = value
					%VisSwitches.caret_column = %VisSwitches.text.length()
				"light_switches":
					%LightSwitches.text = value
					%LightSwitches.caret_column = %LightSwitches.text.length()
				"map_path":
					%MapPath.text = value
					%MapPath.caret_column = %MapPath.text.length()
				"output_path":
					%OutputPath.text = value
					%OutputPath.caret_column = %OutputPath.text.length()
				"game_path":
					%GamePath.text = value
					%GamePath.caret_column = %GamePath.text.length()
				"mod":
					%Mod.text = value
					%Mod.caret_column = %Mod.text.length()
				"bsp_enabled":
					%BspEnabled.set_pressed_no_signal(value)
				"vis_enabled":
					%VisEnabled.set_pressed_no_signal(value)
				"light_enabled":
					%LightEnabled.set_pressed_no_signal(value)
				"launch_after_compile":
					%LaunchAfterCompile.set_pressed_no_signal(value)
		_:
			pass


func _set_bsp_path(path: String) -> void:
	Config.set_config_value("q1", "bsp_path", path)


func _set_vis_path(path: String) -> void:
	Config.set_config_value("q1", "vis_path", path)


func _set_light_path(path: String) -> void:
	Config.set_config_value("q1", "light_path", path)


func _set_map_path(path: String) -> void:
	Config.set_config_value("q1", "map_path", path)


func _set_output_path(path: String) -> void:
	Config.set_config_value("q1", "output_path", path)


func _set_game_path(path: String) -> void:
	Config.set_config_value("q1", "game_path", path)


func _set_mod(path: String) -> void:
	Config.set_config_value("q1", "mod", path)


func _set_bsp_switches(value) -> void:
	Config.set_config_value("q1", "bsp_switches", value)


func _set_vis_switches(value) -> void:
	Config.set_config_value("q1", "vis_switches", value)


func _set_light_switches(value) -> void:
	Config.set_config_value("q1", "light_switches", value)


func _on_bsp_enabled(enabled: bool) -> void:
	Config.set_config_value("q1", "bsp_enabled", enabled)


func _on_vis_enabled(enabled: bool) -> void:
	Config.set_config_value("q1", "vis_enabled", enabled)


func _on_light_enabled(enabled: bool) -> void:
	Config.set_config_value("q1", "light_enabled", enabled)


func _on_launch_after_compile_toggled(value: bool) -> void:
	Config.set_config_value("q1", "launch_after_compile", value)


func _show_bsp_browser() -> void:
	%SelectBspDialog.current_path = Config.get_config_value("q1", "bsp_path")
	%SelectBspDialog.popup_centered()


func _show_vis_browser() -> void:
	%SelectVisDialog.current_path = Config.get_config_value("q1", "vis_path")
	%SelectVisDialog.popup_centered()


func _show_light_browser() -> void:
	%SelectLightDialog.current_path = Config.get_config_value("q1", "light_path")
	%SelectLightDialog.popup_centered()


func _show_game_browser() -> void:
	%SelectGameDialog.current_path = Config.get_config_value("q1", "game_path")
	%SelectGameDialog.popup_centered()


func _show_map_browser() -> void:
	%SelectMapDialog.current_path = Config.get_config_value("q1", "map_path")
	%SelectMapDialog.popup_centered()


func _show_output_browser() -> void:
	%SelectOutputDialog.current_path = Config.get_config_value("q1", "output_path") + "/"
	%SelectOutputDialog.popup_centered()


func _run_game() -> void:
	var game_path: String = Config.get_config_value("q1", "game_path")
	var map: String = Config.get_config_value("q1", "map_path").get_file().rstrip(".map")
	var basedir: String = Config.get_config_value("q1", "game_path").get_base_dir()
	var mod: String = Config.get_config_value("q1", "mod")
	OS.create_process(game_path, ["-basedir", basedir, "+game", mod, "+map", map])


func _compile_bsp():
	var map_path: String = Config.get_config_value("q1", "map_path")
	var bsp_path: String = Config.get_config_value("q1", "bsp_path")
	var output_path: String = Config.get_output_path("q1")
	var switches: String = Config.get_config_value("q1", "bsp_switches")
	var args: String
	args = bsp_path + " " + map_path
	if switches:
		args += " " + switches
	args += " " + output_path
	_run_compiler(args)


func _compile_vis():
	var vis_path: String = Config.get_config_value("q1", "vis_path")
	var switches: String = Config.get_config_value("q1", "vis_switches")
	var output_path: String = Config.get_output_path("q1")
	var args := vis_path
	if switches:
		args += " " + switches
	args += " " + output_path
	_run_compiler(args)


func _compile_light():
	var light_path: String = Config.get_config_value("q1", "light_path")
	var switches: String = Config.get_config_value("q1", "light_switches")
	var output_path: String = Config.get_output_path("q1")
	var args := light_path
	if switches:
		args += " " + switches
	args += " " + output_path
	_run_compiler(args)


func _run_compiler(args) -> void:
	if OS.get_name() == "Linux":
		var terminals: Array[String] = ["gnome-terminal", "xfce4-terminal", "konsole",
				"guake", "yakuake", "terminator", "tilix", "kitty", "xterm"]
		var selected_terminal: String
		for terminal in terminals:
			var exit_code = OS.execute("command", ["-v", terminal], [], true, false)
			if exit_code == 0:
				selected_terminal = terminal
				break
		#args += "; sleep 2" # Wait for x secs before auto-closing
		#args += "; exec bash" # Keep terminal open
		#args += "; read" # Keep terminal open until Enter is pressed
		_compiler_pid = OS.create_process(selected_terminal, ["--", "bash", "-c", args])
	elif OS.get_name() == "Windows":
		var args_array = args.split(" ", false) as Array
		var exe = args_array.pop_front()
		_compiler_pid = OS.create_process(exe, args_array, true)
	%CompilerRunCheck.start()
	_is_compiling = true


func _compile_selected() -> void:
	_cancel_compilation()
	if Config.get_config_value("q1", "bsp_enabled"):
		_compilation_queue.append("bsp")
	if Config.get_config_value("q1", "vis_enabled"):
		_compilation_queue.append("vis")
	if Config.get_config_value("q1", "light_enabled"):
		_compilation_queue.append("light")
	_start_next_queued_action()


func _cancel_compilation() -> void:
	if _is_compiling:
		OS.kill(_compiler_pid)
	_compilation_queue.clear()


func _start_next_queued_action() -> void:
	var next_action = _compilation_queue.pop_front()
	match next_action:
		"bsp":
			_compile_bsp()
		"vis":
			_compile_vis()
		"light":
			_compile_light()
		_:
			if Config.get_config_value("q1", "launch_after_compile"):
				_run_game()


func _clear_help() -> void:
	%ConsoleOutput.text = ""


func _print_bsp_help() -> void:
	var output: Array[String]
	OS.execute(%BspPath.text, [], output)
	_set_help_text(output)
	%HelpPanel.show()
	%ButtonsPanel.hide()


func _print_vis_help() -> void:
	var output: Array[String]
	OS.execute(%VisPath.text, [], output)
	_set_help_text(output)
	%HelpPanel.show()
	%ButtonsPanel.hide()


func _print_light_help() -> void:
	var output: Array[String]
	OS.execute(%LightPath.text, [], output)
	_set_help_text(output)
	%HelpPanel.show()
	%ButtonsPanel.hide()


func _close_help() -> void:
	%HelpPanel.hide()
	%ButtonsPanel.show()


func _set_help_text(text) -> void:
	_clear_help()
	if text is String:
		%ConsoleOutput.text = text
	if text is Array:
		for line in text:
			%ConsoleOutput.text += line
	%ConsoleOutput.scroll_to_line(0)


func _on_compiler_run_check_timeout() -> void:
	_is_compiling = OS.is_process_running(_compiler_pid)
	if not _is_compiling:
		%CompilerRunCheck.stop()
		_start_next_queued_action()
