extends Button


func _ready() -> void:
	pressed.connect(Runner.run_game)
