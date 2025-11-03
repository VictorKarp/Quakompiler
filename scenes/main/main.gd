class_name Main
extends Control


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
		Runner.run_game()


func _on_pause_after_single_toggled(value: bool) -> void:
	Config.set_game_value("pause_after_single", value)


func _on_pause_after_batch_toggled(value: bool) -> void:
	Config.set_game_value("pause_after_batch", value)
