extends Sprite2D

var hit_flash_tween: Tween
var die_tween: Tween

func flash() -> void:
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()

	material.set_shader_parameter("white_percent", 1.0)
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(material, "shader_parameter/white_percent", 0.0, 0.3)

func die() -> void:
	if die_tween != null and die_tween.is_valid():
		die_tween.kill()

	material.set_shader_parameter("opacity_percent", 1.0)
	self.flash()
	die_tween = create_tween()
	die_tween.tween_property(material, "shader_parameter/opacity_percent", 0.0, 0.4)
