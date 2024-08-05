class_name Player
extends CharacterBody2D

# Scene related variables
@export var canvas_controller: CanvasController
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Basic speed
@export var SPEED: float = 100.0

# Status 
@export var max_health: float = 100.0
@export var max_soul: float = 100.0
var damage: float = 10.0
var current_health: float = 0.0
var current_soul: float = 0.0
var current_idle_animation: String
var current_walking_animation: String

# Dash control
var dash_allowed: bool = true
var dash_active: bool = false
@export var DASH_VELOCITY: float = 400.0
@export var DASH_TIME: float = 0.2
@export var DASH_COOLDOWN: float = 1.0
@onready var dash_cooldown_timer: Timer = $DashCooldown
@onready var dash_timer: Timer = $DashTimer

# Elements
var selected_elements: Array[Element] = []
var elements_mix: Array[Element] = []
var main_effect_probability: float = 0.3
var secondary_effect_probability: float = 0.1
@export var ATTACK_TIME: float = 0.8
@export var ATTACK_COOLDOWN: float = 1
@onready var attack_timer: Timer = $AttackTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldown
var is_attacking: bool = false
var can_attack: bool = true

@export var shader: ShaderMaterial

# Current form
var current_attack_type: Element.AttackType
var current_attacl_mode: Element.AttackMode
var current_main_effect: Element.Effects
var current_secondary_effect: Element.Effects
var current_base_element: Element

signal player_attacks(attack_info: Dictionary)

func _ready():
	current_health = max_health
	current_soul = max_soul
	dash_cooldown_timer.wait_time = DASH_COOLDOWN
	dash_timer.wait_time = DASH_TIME
	attack_timer.wait_time = ATTACK_TIME
	attack_cooldown_timer.wait_time = ATTACK_COOLDOWN
	selected_elements = Gamemanager.get_selected_elements()
	current_idle_animation = "idle"
	current_walking_animation = "walk"
	animate_player(0, 0)
	animated_sprite.material.set_shader_parameter("AUX_Color", normalize_color_vector(Vector4(230, 3, 251, 255)))

func _process(delta):
	var horizontal_direction: float = Input.get_axis("move_left", "move_right");
	var vertical_direction: float = Input.get_axis("move_up", "move_down");
	var applied_velocity: float = set_current_velocity(Input.is_action_pressed("dodge"));
	
	var temp_vector = Vector2(horizontal_direction, vertical_direction);
	
	if horizontal_direction && vertical_direction:
		temp_vector = temp_vector.normalized()
	
	if !is_attacking:
		apply_velocity_calculated(temp_vector.x, temp_vector.y, applied_velocity, delta);
		animate_player(temp_vector.x, temp_vector.y)
	
		if Input.is_action_just_pressed("add_element_a"):
			add_element_mix(selected_elements[0])
			
		if Input.is_action_just_pressed("add_element_b"):
			add_element_mix(selected_elements[1])
			
		if Input.is_action_just_pressed("add_element_c"):
			add_element_mix(selected_elements[2])
		
		if Input.is_action_just_pressed("add_element_d"):
			add_element_mix(selected_elements[3])
		
		if Input.is_action_just_pressed("mix"):
			mix()
		
		if Input.is_action_just_pressed("attack"):
			attack(temp_vector)
	else:
		apply_velocity_calculated(0, 0, applied_velocity, delta);
	
	move_and_slide();

func add_element_mix(element: Element) -> void:
	if elements_mix.size() == 3:
		elements_mix.pop_front()
		elements_mix.push_back(element)
	else:
		elements_mix.push_back(element)
	
	canvas_controller.update_elements_selected(elements_mix)

func mix() -> void:
	var i: int = 0
	for element in elements_mix:
		if i == 0:
			current_base_element = element
			current_main_effect = element.effect
		elif i == 1:
			current_attack_type = element.attack_type
			current_secondary_effect = element.effect
		else:
			current_attacl_mode = element.attack_mode
		i += 1
	
	change_animation_with_element()
	canvas_controller.clear_selection()
	elements_mix = []

func change_animation_with_element():
	match current_base_element.element_type:
		Element.ElementType.WATER:
			current_idle_animation = "idle_water"
			current_walking_animation = "walk_water"
		Element.ElementType.FIRE:
			current_idle_animation = "idle_fire"
			current_walking_animation = "walk_fire"
		Element.ElementType.EARTH:
			current_idle_animation = "idle_earth"
			current_walking_animation = "walk_earth"
		Element.ElementType.AIR:
			current_idle_animation = "idle_air"
			current_walking_animation = "walk_air"

func attack(direction: Vector2) -> void:
	if can_attack:
		attack_timer.start()
		animated_sprite.play("attack")
		can_attack = false
		is_attacking = true

func apply_velocity_calculated(horizontal_direction: float, vertical_direction: float, applied_velocity: float, delta):
	velocity.x = horizontal_direction * applied_velocity;
	velocity.y = vertical_direction * applied_velocity;

func animate_player(horizontal_direction: float, vertical_direction: float):
	if horizontal_direction > 0:
		animated_sprite.flip_h = false
	elif horizontal_direction < 0:
		animated_sprite.flip_h = true
		
	if horizontal_direction == 0 && vertical_direction == 0:
		animated_sprite.play(current_idle_animation)
	else:
		animated_sprite.play(current_walking_animation)
		
func normalize_color_vector(color: Vector4) -> Vector4:
	return Vector4(color.x / 255, color.y / 255, color.z / 255, color.w / 255)

func set_current_velocity(is_dashing: bool) -> float:
	if dash_active || (is_dashing && dash_allowed):
		if dash_allowed:
			set_dashing_status()
		return DASH_VELOCITY;
	else: 
		return SPEED;

func set_dashing_status() -> void:
	dash_active = true
	dash_allowed = false
	dash_timer.start()
	dash_cooldown_timer.start()

# Timer callbacks
func _on_dash_cooldown_timeout():
	dash_allowed = true

func _on_dash_timer_timeout():
	dash_active = false

func _on_enemy_player_damaged(damage: Dictionary):
	current_health -= damage.get("damage")

func _on_attack_timer_timeout():
	if is_attacking:
		is_attacking = false
		attack_cooldown_timer.start()

func _on_attack_cooldown_timeout():
	can_attack = true
