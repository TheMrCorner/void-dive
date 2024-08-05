class_name CanvasController
extends Control

@export var elements_selected: Array[Slot] = []
@export var elements_available: Array[Slot] = []

func _ready():
	set_elements_available(Gamemanager.get_selected_elements())

func set_elements_available(elements: Array[Element]):
	var i: int = 0
	for element in elements:
		elements_available[i].set_sprite_texture(elements[i].texture)
		i += 1

func update_elements_selected(elements: Array[Element]):
	var i: int = 0
	while i < elements.size():
		elements_selected[i].set_sprite_texture(elements[i].texture)
		i += 1

func clear_selection():
	for element_selected in elements_selected:
		element_selected.set_sprite_texture(null)
