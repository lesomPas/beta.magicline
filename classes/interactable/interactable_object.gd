class_name InteractableObject extends Interactable

@export var no_lab: bool = false
@export var tip: String = ""
@export var no_outline: bool = false

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var label = $Label

var lab_visible: bool = false:
	set(value):
		if no_lab:
			return
		label.visible = value
		lab_visible = value

func _ready() -> void:
	super()

	if has_node("Label"):
		get_node("Label").visible = false

	if !no_lab:
		$Label.add_theme_stylebox_override("normal", preload("res://style/tip.tres"))
		$Label.text = "  " + tip + "  "
	if !no_outline:
		var sm: ShaderMaterial = ShaderMaterial.new()
		sm.shader = preload("res://shader/sprite_outline.gdshader")
		sm.set_shader_parameter("outline_width", 0.0)
		$Sprite2D.material = sm

func _on_body_entered(human: Human) -> void:
	human.register_interactable(self)
	if !no_outline:
		sprite2d.material.set_shader_parameter("outline_width", 1.0)
	if immediate_interact:
		interact(human)

func _on_body_exited(human: Human) -> void:
	human.unregister_interactable(self)
	if !no_outline:
		sprite2d.material.set_shader_parameter("outline_width", 0.0)

func set_label_visible(value: bool) -> void:
	lab_visible = value
