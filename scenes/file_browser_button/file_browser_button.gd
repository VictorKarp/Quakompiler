extends Button

@export var line_edit: LineEdit
@export var mode: FileDialog.FileMode
@onready var file_dialog: FileDialog = get_tree().get_first_node_in_group("file_dialog")


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	if not file_dialog:
		return
	file_dialog.file_mode = mode
	file_dialog.current_path = line_edit.text
	file_dialog.popup_centered()
	file_dialog.line_edit = line_edit
