extends FileDialog

@export var config_key: String
var line_edit: LineEdit


func _ready() -> void:
	match file_mode:
		FileMode.FILE_MODE_OPEN_FILE:
			file_selected.connect(_on_path_selected)
		FileMode.FILE_MODE_OPEN_DIR:
			dir_selected.connect(_on_path_selected)


func open_as_file_browser() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	popup_centered()


func open_as_dir_browser() -> void:
	file_mode = FileDialog.FILE_MODE_OPEN_DIR
	popup_centered()


func _on_path_selected(path: String) -> void:
	line_edit.text = path
	line_edit.caret_column = line_edit.text.length()
	Config.set_game_value(line_edit.config_key, path)
