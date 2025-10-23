extends Control

var _is_loading_config := false


func _ready() -> void:
	%SelectBspPath.pressed.connect(_show_bsp_browser)
	%SelectVisPath.pressed.connect(_show_vis_browser)
	%SelectLightPath.pressed.connect(_show_light_browser)
	%SelectGamePath.pressed.connect(_show_game_browser)
	%RunGame.pressed.connect(_on_run_game_pressed)
	%BspHelp.pressed.connect(_on_bsp_help_pressed)
	%VisHelp.pressed.connect(_on_vis_help_pressed)
	%LightHelp.pressed.connect(_on_light_help_pressed)

	%BspPath.text_changed.connect(_on_config_value_changed)
	%BspSwitches.text_changed.connect(_on_config_value_changed)
	%VisPath.text_changed.connect(_on_config_value_changed)
	%VisSwitches.text_changed.connect(_on_config_value_changed)
	%LightPath.text_changed.connect(_on_config_value_changed)
	%LightSwitches.text_changed.connect(_on_config_value_changed)
	%MapPath.text_changed.connect(_on_config_value_changed)
	%OutputPath.text_changed.connect(_on_config_value_changed)
	%GamePath.text_changed.connect(_on_config_value_changed)
	%ModName.text_changed.connect(_on_config_value_changed)

	%SelectMapPath.pressed.connect(_show_map_browser)
	%SelectOutputFolder.pressed.connect(_show_output_browser)

	%SelectBspDialog.file_selected.connect(_set_bsp_path)
	%SelectVisDialog.file_selected.connect(_set_vis_path)
	%SelectLightDialog.file_selected.connect(_set_light_path)

	%SelectMapDialog.file_selected.connect(_set_map_path)
	%SelectOutputDialog.dir_selected.connect(_set_output_folder)
	%SelectGameDialog.file_selected.connect(_set_game_path)

	%CompileBsp.pressed.connect(_compile_bsp)
	%CompileVis.pressed.connect(_compile_vis)
	%CompileLight.pressed.connect(_compile_light)

	%ClearConsole.pressed.connect(_clear_console)

	%SelectBspDialog.current_path = _get_bsp_path()
	%SelectVisDialog.current_path = _get_vis_path()
	%SelectLightDialog.current_path = _get_light_path()
	%SelectMapDialog.current_path = _get_map_path()
	%SelectOutputDialog.current_path = _get_output_folder()

	_load_config()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("compile_bsp"):
		_compile_bsp()
	if event.is_action_pressed("compile_vis"):
		_compile_vis()
	if event.is_action_pressed("compile_light"):
		_compile_light()
	if event.is_action_pressed("clear_console"):
		_clear_console()
	if event.is_action_pressed("run"):
		_on_run_game_pressed()


func _show_bsp_browser() -> void:
	%SelectBspDialog.popup_centered()


func _show_vis_browser() -> void:
	%SelectVisDialog.popup_centered()


func _show_light_browser() -> void:
	%SelectLightDialog.popup_centered()


func _show_game_browser() -> void:
	%SelectGameDialog.popup_centered()


func _show_map_browser() -> void:
	%SelectMapDialog.popup_centered()


func _show_output_browser() -> void:
	%SelectOutputDialog.popup_centered()


func _on_run_game_pressed() -> void:
	var basedir = _get_game_path().get_base_dir()
	var map = _get_map_name()
	OS.create_process(_get_game_path(), ["-basedir", basedir, "+game",
			_get_mod_name(), "+map", map])


func _compile_bsp() -> void:
	var output = []
	var switches = _get_bsp_switches()
	var args: PackedStringArray
	if switches:
		args = [_get_map_path()]
		args.append_array(switches)
		args.append(_get_output_path())
	else:
		args = [_get_map_path(), _get_output_path()]
	OS.execute(%BspPath.text, args, output)
	_print_array_to_console(output, true, false)


func _compile_vis() -> void:
	var output = []
	var switches = _get_vis_switches()
	var args: PackedStringArray
	if switches:
		args = _get_vis_switches()
		args.append(_get_output_path())
	else:
		args = [_get_output_path()]
	OS.execute(%VisPath.text, args, output)
	_print_array_to_console(output, true, false)


func _compile_light() -> void:
	var output = []
	var switches = _get_light_switches()
	var args: PackedStringArray
	if switches:
		args = switches
		args.append(_get_output_path())
	else:
		args = [_get_output_path()] as PackedStringArray
	OS.execute(%LightPath.text, args, output)
	_print_array_to_console(output, true, false)


func _get_map_path() -> String:
	return %MapPath.text


func _set_map_path(path: String) -> void:
	%MapPath.text = path
	%MapPath.text_changed.emit(path)


func _get_map_name() -> String:
	return _get_map_path().get_file().rstrip(".map")


func _get_output_folder() -> String:
	return %OutputPath.text


func _set_output_folder(folder: String) -> void:
	%OutputPath.text = folder
	%OutputPath.text_changed.emit(folder)


func _get_output_path() -> String:
	return _get_output_folder() + "/" + _get_map_name() + ".bsp"


func _clear_console() -> void:
	%ConsoleOutput.text = ""


func _get_bsp_path() -> String:
	return %BspPath.text


func _set_bsp_path(value: String) -> void:
	%BspPath.text = value
	%BspPath.text_changed.emit(value)


func _get_vis_path() -> String:
	return %VisPath.text


func _set_vis_path(value: String) -> void:
	%VisPath.text = value
	%VisPath.text_changed.emit(value)


func _get_light_path() -> String:
	return %LightPath.text


func _set_light_path(value: String) -> void:
	%LightPath.text = value
	%LightPath.text_changed.emit(value)


func _get_bsp_switches():
	return %BspSwitches.text.split(" ", false)


func _get_bsp_switches_text() -> String:
	return %BspSwitches.text


func _set_bsp_switches(value: String) -> void:
	%BspSwitches.text = value


func _get_vis_switches():
	return %VisSwitches.text.split(" ", false)


func _get_vis_switches_text() -> String:
	return %VisSwitches.text


func _set_vis_switches(value: String) -> void:
	%VisSwitches.text = value


func _get_light_switches():
	return %LightSwitches.text.split(" ", false)


func _get_light_switches_text() -> String:
	return %LightSwitches.text


func _set_light_switches(value: String) -> void:
	%LightSwitches.text = value


func _get_game_path() -> String:
	return %GamePath.text


func _set_game_path(value: String) -> void:
	%GamePath.text = value
	%GamePath.text_changed.emit(value)


func _get_mod_name() -> String:
	return %ModName.text


func _set_mod_name(value: String) -> void:
	%ModName.text = value
	%ModName.text_changed.emit(value)


func _on_bsp_help_pressed() -> void:
	var output: Array
	OS.execute(%BspPath.text, [], output)
	_print_array_to_console(output, true, true)


func _on_vis_help_pressed() -> void:
	var output: Array
	OS.execute(%VisPath.text, [], output)
	_print_array_to_console(output, true, true)


func _on_light_help_pressed() -> void:
	var output: Array
	OS.execute(%LightPath.text, [], output)
	_print_array_to_console(output, true, true)


func _print_array_to_console(array: Array, clear = true,
		scroll_to_top = false) -> void:
	if clear:
		_clear_console()
	for item in array:
		%ConsoleOutput.text += item
	if scroll_to_top:
		%ConsoleOutput.call_deferred("scroll_to_line", 0)



func _on_config_value_changed(_value) -> void:
	_save_config()


func _save_config() -> void:
	if _is_loading_config:
		return
	var config := ConfigFile.new()
	config.set_value("paths", "bsp_path", _get_bsp_path())
	config.set_value("paths", "vis_path", _get_vis_path())
	config.set_value("paths", "light_path", _get_light_path())
	config.set_value("paths", "map_path", _get_map_path())
	config.set_value("paths", "output_folder", _get_output_folder())
	config.set_value("paths", "game_path", _get_game_path())
	config.set_value("switches", "bsp", _get_bsp_switches_text())
	config.set_value("switches", "vis", _get_vis_switches_text())
	config.set_value("switches", "light", _get_light_switches_text())
	config.set_value("launch", "mod_name", _get_mod_name())
	config.save("config.ini")


func _load_config() -> void:
	_is_loading_config = true
	var config = ConfigFile.new()
	var error = config.load("config.ini")
	if error != OK:
		return

	for section in config.get_sections():
		_set_bsp_path(config.get_value("paths", "bsp_path"))
		_set_bsp_switches(config.get_value("switches", "bsp"))
		_set_vis_path(config.get_value("paths", "vis_path"))
		_set_vis_switches(config.get_value("switches", "vis"))
		_set_light_path(config.get_value("paths", "light_path"))
		_set_light_switches(config.get_value("switches", "light"))
		_set_map_path(config.get_value("paths", "map_path"))
		_set_output_folder(config.get_value("paths", "output_folder"))
		_set_game_path(config.get_value("paths", "game_path"))
		_set_mod_name(config.get_value("launch", "mod_name"))

	_is_loading_config = false
