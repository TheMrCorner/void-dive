class_name Slot
extends Panel

@export var sprite: Sprite2D

func set_sprite_texture(texture: Texture2D):
	sprite.set_texture(texture)
	
func get_sprite_texture():
	return sprite.get_texture()
