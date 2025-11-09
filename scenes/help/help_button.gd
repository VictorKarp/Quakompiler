extends Button

@export var help_file: Help


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	var help_topic := ""
	var help_text := ""
	if help_file:
		help_topic = help_file.topic
		help_text = help_file.text
	Events.help_requested.emit(help_topic, help_text)
