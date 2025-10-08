class_name SceneTeleporter extends Interactable

@export_file("*.tscn") var scene_path: String
@export var entry_point: String

func on_interact(human: Human) -> void:
	MagiclineDirector.change_scene(scene_path, entry_point)
