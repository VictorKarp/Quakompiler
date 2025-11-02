extends FoldableContainer

@export var config_name: String


func _ready() -> void:
	folding_changed.connect(_on_folding_changed)
	Config.config_loaded.connect(_on_config_loaded)


func _on_folding_changed(value: bool) -> void:
	Config.set_game_value(config_name, value)


func _on_config_loaded() -> void:
	var value = Config.get_game_value(config_name)
	if value:
		folded = value
