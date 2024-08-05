class_name Element
extends Node

enum ElementType { WATER, FIRE, EARTH, AIR }
enum Effects { NONE, WET, BURN, SLOW, POISON, STUN }
enum AttackType { RANGED, MELEE }
enum AttackMode { AREA, PRECISION }

@export var element_type: ElementType = ElementType.WATER
@export var weak: Array[Element] = []
@export var effect: Effects = Effects.NONE
@export var attack_type: AttackType = AttackType.RANGED
@export var attack_mode: AttackMode = AttackMode.PRECISION

@export var display_name: String = "Element"

@export var texture: Texture2D

func check_weakness(attack_element: Element) -> bool:
	var index: int = weak.find(attack_element)
	if index != 0:
		return true
	else:
		return false
