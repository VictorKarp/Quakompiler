extends Button

@export var os: Enums.os


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	Exporter.export(os)
