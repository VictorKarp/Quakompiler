extends TabContainer


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	tab_changed.connect(_on_tab_changed)


func _on_tab_changed(tab: int) -> void:
	match tab:
		0:
			Config.set_current_game(Enums.game.QUAKE1)
		1:
			Config.set_current_game(Enums.game.QUAKE3)


func _on_config_loaded() -> void:
	match Config.get_current_game():
		Enums.game.QUAKE1:
			current_tab = 0
		Enums.game.QUAKE3:
			current_tab = 1
