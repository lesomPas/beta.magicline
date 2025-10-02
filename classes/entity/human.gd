class_name Human extends Entity

enum BodyStates {
	normal,
	dizzy,
	syncope,
	dying,
	skip
}

var health_attribute: HealthAttribute
var magic_attribute: Attribute
var stamina_attribute: StaminaAttribute

var body_state: BodyStates = BodyStates.normal:
	get(): 
		if direct_body_state != -1:
			return direct_body_state

		if health_attribute == null or stamina_attribute == null:
			return BodyStates.normal

		return max(
			health_attribute.state, 
			stamina_attribute.state,
		)

var direct_body_state: BodyStates = -1
var interactable_objs: Array[InteractableObject] = []

@onready var attribute_component: AttributeComponent = $AttributeComponent

func _ready() -> void:
	health_attribute = attribute_component.find_attribute("health")
	magic_attribute = attribute_component.find_attribute("magic")
	stamina_attribute = attribute_component.find_attribute("stamina")

	health_attribute.player = self
	stamina_attribute.player = self

func body_process() -> void:
	pass

func register_interactable(interactalbe_obj: InteractableObject) -> void:
	if !interactable_objs.is_empty():
		interactable_objs.back().lab_visible = false
	if interactalbe_obj not in interactable_objs:
		interactalbe_obj.lab_visible = true
		interactable_objs.append(interactalbe_obj)

func unregister_interactable(interactable_obj: InteractableObject) -> void:
	interactable_objs.erase(interactable_obj)
	interactable_obj.lab_visible = false
	if !interactable_objs.is_empty():
		interactable_objs.back().lab_visible = true

func skip() -> void:
	animation_player.play("die")

func internal_get_next_state(state: PhysicsState) -> int:
	if body_state == BodyStates.skip:
		if not animation_player.is_playing():
			get_tree().paused = true
		return PhysicsStateMachine.KeepCurrent if physics_state_machine.current_state == PhysicsState.skip else PhysicsState.skip 
	return super(state)

func internal_tick_physics(state: PhysicsState, delta: float) -> void:
	body_process()
	super(state, delta)

func internal_transition_state(from: int, to: int) -> void:
	if to == PhysicsState.hurt:
		print_debug(name)
		health_attribute.subtract(pending_damage.amount)
	super(from, to)

func commit_information(_name: String = "", _cn_name: String = "", _id: String = "") -> void:
	MagiclineDirector.register_human_info(self, _name, _cn_name, _id)
