extends TabContainer


func _ready() -> void:
	tab_changed.connect(_on_tab_changed)


func _on_tab_changed(tab: int) -> void:
	match tab:
		0:
			Config.current_game = Enums.game.QUAKE1
		1:
			Config.current_game = Enums.game.QUAKE3
