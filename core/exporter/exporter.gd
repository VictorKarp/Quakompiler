extends Node


func export() -> void:
	var lines := ""
	var filename: String
	var mapname = Config.get_game_value("map_path").get_file().rstrip(".map")
	var bsp := false
	var vis := false
	var light := false
	var bspc := false
	var run := false
	var pause := false
	var is_quake3 = Config.get_current_game() == Enums.game.QUAKE3

	if OS.get_name() == "Linux":
		lines = "#!/bin/bash\n"

	filename = mapname

	if Config.get_game_value("export_bsp"):
		lines += "\n" + _convert_commands_to_line(Compiler.get_bsp_commands())
		bsp = true
	if Config.get_game_value("export_vis"):
		lines += "\n" + _convert_commands_to_line(Compiler.get_vis_commands())
		vis = true
	if Config.get_game_value("export_light"):
		lines += "\n" + _convert_commands_to_line(Compiler.get_light_commands())
		light = true
	if is_quake3:
		if Config.get_game_value("export_bspc"):
			lines += "\n" + _convert_commands_to_line(Compiler.get_bspc_commands())
			bspc = true
	if Config.get_game_value("export_run"):
		lines += "\n" + Runner.get_run_commands()
		run = true
	if Config.get_game_value("export_pause"):
		if OS.get_name() == "Windows":
			lines += " && pause"
		else:
			lines += " ;read"
		pause = true

	if not bsp and not vis and not light and not run:
		if not is_quake3:
			return
		if not bspc:
			return

	if bsp and vis and light:
		filename += "_full"
	else:
		if bsp:
			filename += "_bsp"
		if vis:
			filename += "_vis"
		if light:
			filename += "_light"
	if is_quake3 and bspc:
		filename += "_bots"
	if pause:
		filename += "_pause"
	if run:
		filename += "_run"

	if OS.get_name() == "Windows":
		filename += ".bat"
	else:
		filename += ".sh"

	var export_path = Config.get_game_value("export_path")
	var full_path: String

	if not DirAccess.dir_exists_absolute(export_path) or export_path == "":
		full_path = filename
	else:
		full_path = export_path + "/" + filename

	var file = FileAccess.open(full_path, FileAccess.WRITE)
	file.store_string(lines)

	if OS.get_name() == "Linux":
		OS.execute("chmod", ["a+x", full_path], [], false)


func _convert_commands_to_line(commands: Array) -> String:
	var line = commands[0] + " " + commands[1]
	line = line.replace("  ", " ")
	return line
