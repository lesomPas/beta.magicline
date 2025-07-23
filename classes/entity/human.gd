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
	get(): return max(health_attribute.state, stamina_attribute.state)

@onready var attribute_component: AttributeComponent = $AttributeComponent

func _ready() -> void:
	health_attribute = attribute_component.find_attribute("health")
	magic_attribute = attribute_component.find_attribute("magic")
	stamina_attribute = attribute_component.find_attribute("stamina")

	health_attribute.player = self
	stamina_attribute.player = self

func commit_information(_information: Dictionary[String, String]) -> void:
	NameMap.name_map[_information["name"]] = self
	NameMap.cn_name_map[_information["cn_name"]] = self
	NameMap.id_map[_information["id"]] = self
