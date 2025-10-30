extends Button

@export var tabs: TabContainer
@export var index := 0


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	tabs.current_tab = index
