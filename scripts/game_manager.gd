class_name GameManager
extends Node

@export var available_elements: Array[Element] = []
@export var testing: Array[String] = []

var selected_elements: Array[Element] = []

func _ready():
	selected_elements = available_elements

func get_selected_elements():
	return selected_elements
