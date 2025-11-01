extends PanelContainer

@export var left_panel: Control
@export var right_panel: Control


func _ready() -> void:
	Events.help_requested.connect(_on_help_requested)
	%Close.pressed.connect(_close)
	%HelpText.meta_clicked.connect(_on_help_meta_clicked)
	hide()


func _on_help_requested(topic, text, open_on_side: Enums.side) -> void:
	%HelpTopic.text = topic
	%HelpText.text = text
	show()
	match open_on_side:
		Enums.side.LEFT:
			left_panel.hide()
		Enums.side.RIGHT:
			right_panel.hide()


func _close() -> void:
	hide()
	left_panel.show()
	right_panel.show()

func _on_help_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
