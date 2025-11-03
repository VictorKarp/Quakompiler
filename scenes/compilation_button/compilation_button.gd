extends Button

enum Stage {
	BSP = 0,
	VIS = 1,
	LIGHT = 2,
	SELECTED = 3,
}
@export var stage: Stage


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	match stage:
		Stage.BSP:
			Compiler.compile_bsp(Enums.compile_mode.SINGLE)
		Stage.VIS:
			Compiler.compile_vis(Enums.compile_mode.SINGLE)
		Stage.LIGHT:
			Compiler.compile_light(Enums.compile_mode.SINGLE)
		Stage.SELECTED:
			Compiler.compile_selected()
