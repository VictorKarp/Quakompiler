extends Window


func _ready() -> void:
	Events.help_requested.connect(_on_help_requested)
	%HelpText.meta_clicked.connect(_on_help_meta_clicked)
	close_requested.connect(hide)
	hide()


func _on_help_requested(topic, text) -> void:
	if not visible:
		size.x = min(600, get_parent().get_viewport().get_visible_rect().size.x - 40)
		size.y = min(600, get_parent().get_viewport().get_visible_rect().size.y - 80)
		popup_centered()
	%HelpTopic.text = topic
	%HelpText.text = text


func _on_help_meta_clicked(meta) -> void:
	OS.shell_open(str(meta))
