class_name Projectile
extends Area2D

@export var SPEED: float = 1000.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var current_direction: Vector2

func set_projectile(direction: Vector2, element: Element):
	match element.element_type:
		Element.ElementType.WATER:
			animated_sprite.play("water")
		Element.ElementType.FIRE:
			animated_sprite.play("fire")
		Element.ElementType.EARTH:
			animated_sprite.play("earth")
		Element.ElementType.AIR:
			animated_sprite.play("air")
	current_direction = direction

func _process(delta):
	
