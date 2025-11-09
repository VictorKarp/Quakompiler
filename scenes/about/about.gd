extends MarginContainer

var _loaded := false


func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	%GUI.meta_clicked.connect(_on_meta_clicked)
	%HeaderButton.pressed.connect(_on_headerbutton_pressed)


func _on_visibility_changed() -> void:
	if visible and not _loaded:
		_loaded = true

		%GUI.text = FileAccess.open("res://LICENSE.txt", FileAccess.READ).get_as_text()
		%Godot.text = FileAccess.open("res://LICENSE_GODOT.txt", FileAccess.READ).get_as_text()
		%GodotThirdParty.text = FileAccess.open("res://LICENSE_3RD_PARTY.txt",
				FileAccess.READ).get_as_text()
		%Fonts.text = FileAccess.open("res://fonts/inter/inter_ofl.txt", FileAccess.READ).get_as_text()


func _on_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func _on_headerbutton_pressed() -> void:
	OS.shell_open("https://github.com/VictorKarp/Quakompiler")
