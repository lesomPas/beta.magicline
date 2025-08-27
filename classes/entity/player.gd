class_name Player extends Human

var interacting_with: Array[Interactable] = []

@onready var interactiom_icon: AnimatedSprite2D = $InteractiomIcon


func register_interactable(value: Interactable) -> void:
	if physics_state_machine.current_state == PhysicsState.skip:
		return
	if value in interacting_with:
		return
	interacting_with.append(value)

func unregister_interactable(value: Interactable) -> void:
	interacting_with.erase(value)

func skip() -> void:
	super()
	interacting_with.clear()
	# get_tree().reload_current_scene()

func tick_physics(state: PhysicsState, delta: float) -> void:
	interactiom_icon.visible = !interacting_with.is_empty()

	internal_tick_physics(state, delta)
