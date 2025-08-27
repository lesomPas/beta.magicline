extends VBoxContainer

@onready var attribute_component: AttributeComponent
@onready var health_point_bar: TextureProgressBar = $HealthPointBar
@onready var magic_point_bar: TextureProgressBar = $MagicPointBar
@onready var stamina_point_bar: TextureProgressBar = $StaminaPointBar

func _ready() -> void:
	await %player.ready
	attribute_component= %player.attribute_component
	attribute_component.find_attribute("health").attribute_changed.connect(
		update_health
	)
	attribute_component.find_attribute("magic").attribute_changed.connect(
		update_magic
	)
	attribute_component.find_attribute("stamina").attribute_changed.connect(
		update_stamina
	)
	

func _update() -> void:
	update_health(attribute_component.find_attribute("health"))
	update_magic(attribute_component.find_attribute("magic"))
	update_stamina(attribute_component.find_attribute("stamina"))

func update_health(attribute: Attribute) -> void:
	var percentage: float = attribute.value() / attribute.upper_limit
	health_point_bar.value = percentage

func update_magic(attribute: Attribute) -> void:
	var percentage: float = attribute.value() / attribute.upper_limit
	magic_point_bar.value = percentage

func update_stamina(attribute: Attribute) -> void:
	var percentage: float = attribute.value() / attribute.upper_limit
	stamina_point_bar.value = percentage
