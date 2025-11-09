extends Node


func export(os: Enums.os) -> void:
	var lines := ""
	var filename: String
	var mapname = Config.get_game_value("map_path").get_file().rstrip(".map")
	var bsp := false
	var vis := false
	var light := false
	var bspc := false
	var run := false
	var pause := false

	if os == Enums.os.LINUX:
		lines = "#!/bin/bash\n"

	match Config.get_current_game():
		Enums.game.QUAKE1:
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
			if Config.get_game_value("export_run"):
				lines += "\n" + Runner.get_run_commands()
				run = true
			if Config.get_game_value("export_pause"):
				if os == Enums.os.WINDOWS:
					lines += " && pause"
				else:
					lines += " ;read"
				pause = true

			if (
				not bsp
				and not vis
				and not light
				and not run
			):
				return

			if (
				bsp
				and vis
				and light
			):
				filename += "_full"
			else:
				if bsp:
					filename += "_bsp"
				if vis:
					filename += "_vis"
				if light:
					filename += "_light"
			if pause:
				filename += "_pause"
			if run:
				filename += "_run"

	if os == Enums.os.WINDOWS:
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

	if os == Enums.os.LINUX:
		OS.execute("chmod", ["a+x", filename], [], false)


func _convert_commands_to_line(commands: Array) -> String:
	var line = commands[0] + " " + commands[1]
	line = line.replace("  ", " ")
	return line
