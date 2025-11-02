extends Button

@export var topic := ""
@export_multiline var help_text := ""


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Events.help_requested.emit(topic, help_text)
