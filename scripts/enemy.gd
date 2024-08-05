extends CharacterBody2D

# Movement
const SPEED = 600.0
var player: Node2D = null
@export var timer_time: float = 1.5
@onready var movement_timer: Timer = $MovementTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var moving: bool = false
var direction: Vector2

# Stats
@export var damage: float = 10.0
@export var damage_type: Element = null
var idle_animation: String 
var death_animation: String

signal player_damaged(damage: Dictionary)

func _ready():
	movement_timer.wait_time = timer_time
	var elements_selected: Array[Element] = Gamemanager.get_selected_elements()
	set_element_damage(elements_selected)

func _process(delta):
	if player != null:
		direction.x = player.global_position.x - position.x
		direction.y = player.global_position.y - position.y
		direction = direction.normalized()
		moving = true
	else:
		if !moving:
			direction.x = randf_range(0, 1)
			direction.y = randf_range(0, 1)
			moving = true
			movement_timer.start()
	
	set_current_velocity(delta)
	move_and_slide()

func set_element_damage(elements: Array[Element]):
	var probability: float = randf_range(0, 1)
	print(str(probability))
	if probability <= 0.7 && probability > 0.6:
		damage_type = elements[0]
	elif probability > 0.7 && probability <= 0.8:
		damage_type = elements[1]
	elif probability > 0.8 && probability <= 0.9:
		damage_type = elements[2]
	elif probability > 0.9 && probability <= 1:
		damage_type = elements[3]
	
	set_animation()
	
func set_animation():
	print(str(damage_type))
	if damage_type != null:
		match damage_type.element_type:
			Element.ElementType.WATER:
				idle_animation = "idle_water"
				death_animation = "death_water"
			Element.ElementType.FIRE:
				idle_animation = "idle_fire"
				death_animation = "death_fire"
			Element.ElementType.EARTH:
				idle_animation = "idle_earth"
				death_animation = "death_earth"
			Element.ElementType.AIR:
				idle_animation = "idle_air"
				death_animation = "death_air"
	else: 
		idle_animation = "idle_normal"
		death_animation = "death"
	
	animated_sprite.play(idle_animation)

func set_current_velocity(delta):
	velocity.x = direction.x * SPEED * delta
	velocity.y = direction.y * SPEED * delta

func _on_killzone_player_hit():
	var damage: Dictionary = {
		"damage": damage,
		"element": damage_type
	}
	player_damaged.emit(damage)

func _on_detect_area_player_detected(body: Node2D):
	# Start following
	if body != null:
		player = body
	# Stop following
	else:
		moving = false
		player = null


func _on_movement_timer_timeout():
	moving = false
