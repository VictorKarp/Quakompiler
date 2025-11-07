class_name CompilationButton
extends Button

enum Stage {
	SELECTED = 0,
	BSP = 1,
	VIS = 2,
	LIGHT = 3,
	BSPC = 4,
}
@export var stage: Stage


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	match stage:
		Stage.SELECTED:
			Compiler.compile_selected()
		Stage.BSP:
			Compiler.compile_bsp(Enums.compile_mode.SINGLE)
		Stage.VIS:
			Compiler.compile_vis(Enums.compile_mode.SINGLE)
		Stage.LIGHT:
			Compiler.compile_light(Enums.compile_mode.SINGLE)
		Stage.BSPC:
			Compiler.compile_bspc(Enums.compile_mode.SINGLE)
