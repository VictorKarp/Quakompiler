extends ScrollContainer

@export var game := Enums.game.QUAKE1


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	get_parent().visibility_changed.connect(_load_scroll)


func _on_config_loaded() -> void:
	_load_scroll()


func _load_scroll() -> void:
	if not get_parent().visible:
		return
	await get_tree().process_frame
	match game:
		Enums.game.QUAKE1:
			set_deferred("scroll_vertical", Config.get_application_value("q1_scroll"))
		Enums.game.QUAKE2:
			set_deferred("scroll_vertical", Config.get_application_value("q2_scroll"))
		Enums.game.QUAKE3:
			set_deferred("scroll_vertical", Config.get_application_value("q3_scroll"))
	get_parent().visibility_changed.disconnect(_load_scroll)
