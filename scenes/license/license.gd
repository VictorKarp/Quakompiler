extends MarginContainer

var _loaded := false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible and not _loaded:
		_loaded = true

		%GUI.text = FileAccess.open("res://LICENSE.txt", FileAccess.READ).get_as_text()
		%Godot.text = FileAccess.open("res://LICENSE_GODOT.txt", FileAccess.READ).get_as_text()
		%GodotThirdParty.text = FileAccess.open("res://LICENSE_3RD_PARTY.txt",
				FileAccess.READ).get_as_text()
