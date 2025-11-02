extends FoldableContainer

@export var config_name: String


func _ready() -> void:
	folding_changed.connect(_on_folding_changed)
	Config.config_value_changed.connect(_on_config_value_changed)


func _on_folding_changed(value: bool) -> void:
	Config.set_config_value("q1", config_name, value)


func _on_config_value_changed(game: String, key: String, value) -> void:
	if key == config_name:
		folded = value
