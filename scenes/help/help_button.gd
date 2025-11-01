extends Button

@export var topic := ""
@export_multiline var help_text := ""
@export var open_on_side: Enums.side


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Events.help_requested.emit(topic, help_text, open_on_side)
