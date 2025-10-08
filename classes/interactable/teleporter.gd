class_name Teleporter extends Interactable

@export var entry_point: String

func on_interact(human: Human) -> void:
	var tree: SceneTree = get_tree()

	for node in tree.get_nodes_in_group("/main/scene/teleporters"):
		if node.name == entry_point:
			tree.current_scene.update_player(node.global_position, node.direction)
			break
