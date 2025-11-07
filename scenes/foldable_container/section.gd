class_name Section
extends FoldableContainer

@export var game: Enums.game
@export var config_name: String


func _init() -> void:
	Config.config_loaded.connect(_on_config_loaded)


func _ready() -> void:
	folding_changed.connect(_on_folding_changed)


func _on_folding_changed(value: bool) -> void:
	Config.set_game_value(config_name, value)


func _on_config_loaded() -> void:
	var value = Config.get_game_value(config_name, game)
	if value:
		folded = value
