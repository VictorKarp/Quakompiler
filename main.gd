extends Control


func _ready() -> void:
	%SelectBspPath.pressed.connect(_on_select_bsp_path_pressed)
	%SelectVisPath.pressed.connect(_on_select_vis_path_pressed)
	%SelectLightPath.pressed.connect(_on_select_light_path_pressed)

	%BspPath.text_changed.connect(_on_config_value_changed)
	%BspSwitches.text_changed.connect(_on_config_value_changed)
	%VisPath.text_changed.connect(_on_config_value_changed)
	%VisSwitches.text_changed.connect(_on_config_value_changed)
	%LightPath.text_changed.connect(_on_config_value_changed)
	%LightSwitches.text_changed.connect(_on_config_value_changed)
	%MapPath.text_changed.connect(_on_config_value_changed)
	%OutputPath.text_changed.connect(_on_config_value_changed)

	%SelectMapPath.pressed.connect(_on_select_map_path_pressed)
	%SelectOutputFolder.pressed.connect(_on_select_output_folder_pressed)

	%SelectBspDialog.file_selected.connect(_on_bsp_selected)
	%SelectVisDialog.file_selected.connect(_on_vis_selected)
	%SelectLightDialog.file_selected.connect(_on_light_selected)

	%SelectMapDialog.file_selected.connect(_on_map_selected)
	%SelectOutputDialog.dir_selected.connect(_on_output_selected)

	%CompileBsp.pressed.connect(_on_compile_bsp_pressed)
	%CompileVis.pressed.connect(_on_compile_vis_pressed)
	%CompileLight.pressed.connect(_on_compile_light_pressed)

	%ClearConsole.pressed.connect(_clear_console)

	%SelectBspDialog.current_path = _get_bsp_path()
	%SelectVisDialog.current_path = _get_vis_path()
	%SelectLightDialog.current_path = _get_light_path()
	%SelectMapDialog.current_path = _get_map_path()
	%SelectOutputDialog.current_path = _get_output_folder()

	_load_config()


func _on_select_bsp_path_pressed() -> void:
	%SelectBspDialog.popup_centered()


func _on_select_vis_path_pressed() -> void:
	%SelectVisDialog.popup_centered()


func _on_select_light_path_pressed() -> void:
	%SelectLightDialog.popup_centered()


func _on_select_map_path_pressed() -> void:
	%SelectMapDialog.popup_centered()


func _on_select_output_folder_pressed() -> void:
	%SelectOutputDialog.popup_centered()


func _on_bsp_selected(path: String) -> void:
	%BspPath.text = path
	%BspPath.text_changed.emit(path)


func _on_vis_selected(path: String) -> void:
	%VisPath.text = path
	%VisPath.text_changed.emit(path)


func _on_light_selected(path: String) -> void:
	%LightPath.text = path
	%LightPath.text_changed.emit(path)


func _on_map_selected(path: String) -> void:
	%MapPath.text = path
	%MapPath.text_changed.emit(path)


func _on_output_selected(path: String) -> void:
	%OutputPath.text = path
	%OutputPath.text_changed.emit(path)


func _on_compile_bsp_pressed() -> void:
	_clear_console()
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
	for item in output:
		%ConsoleOutput.text += item


func _on_compile_vis_pressed() -> void:
	_clear_console()
	var output = []
	var switches = _get_vis_switches()
	var args: PackedStringArray
	if switches:
		args = _get_vis_switches()
		args.append(_get_output_path())
	else:
		args = [_get_output_path()]
	OS.execute(%VisPath.text, args, output)
	for item in output:
		%ConsoleOutput.text += item


func _on_compile_light_pressed() -> void:
	_clear_console()
	var output = []
	var switches = _get_light_switches()
	var args: PackedStringArray
	if switches:
		args = switches
		args.append(_get_output_path())
	else:
		args = [_get_output_path()] as PackedStringArray
	OS.execute(%LightPath.text, args, output)
	for item in output:
		%ConsoleOutput.text += item


func _get_map_path() -> String:
	return %MapPath.text


func _set_map_path(path: String) -> void:
	%MapPath.text = path


func _get_map_name() -> String:
	return _get_map_path().get_file().rstrip(".map")


func _get_output_folder() -> String:
	return %OutputPath.text


func _set_output_folder(folder: String) -> void:
	%OutputPath.text = folder


func _get_output_path() -> String:
	return _get_output_folder() + "/" + _get_map_name() + ".bsp"


func _clear_console() -> void:
	%ConsoleOutput.text = ""


func _get_bsp_path() -> String:
	return %BspPath.text


func _set_bsp_path(value: String) -> void:
	%BspPath.text = value


func _get_vis_path() -> String:
	return %VisPath.text


func _set_vis_path(value: String) -> void:
	%VisPath.text = value


func _get_light_path() -> String:
	return %LightPath.text


func _set_light_path(value: String) -> void:
	%LightPath.text = value


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


func _on_config_value_changed(_value) -> void:
	_save_config()


func _save_config() -> void:
	var config := ConfigFile.new()
	config.set_value("paths", "bsp_path", _get_bsp_path())
	config.set_value("paths", "vis_path", _get_vis_path())
	config.set_value("paths", "light_path", _get_light_path())
	config.set_value("paths", "map_path", _get_map_path())
	config.set_value("paths", "output_folder", _get_output_folder())
	config.set_value("switches", "bsp", _get_bsp_switches_text())
	config.set_value("switches", "vis", _get_vis_switches_text())
	config.set_value("switches", "light", _get_light_switches_text())
	config.save("config.ini")


func _load_config() -> void:
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
