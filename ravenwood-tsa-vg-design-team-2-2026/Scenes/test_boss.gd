extends CharacterBody2D

# Stats
@export var max_health: float = 100.0
@export var damage_per_hit: float = 10.0
@export var next_level_unlock: int = 2  # Set in inspector per level
var health: float
var fight_started: bool = false
var victory_item = preload("res://victory_item.tscn")

# Movement - vertical only
@export var float_speed: float = 50.0
@export var float_range: float = 100.0
var start_y: float
var move_direction: float = 1.0

# Move/Wait pattern
var is_moving: bool = true
@export var move_time: float = 2.0
@export var wait_time: float = 1.0
var state_timer: float = 0.0

# Attack
var projectile_scene = preload("res://enemy_projectile.tscn")
@export var shots_per_attack: int = 3
@export var shot_spread: float = 0.3

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var health_bar = $HealthBar

func _ready():
	add_to_group("Enemy")
	
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	
	start_y = global_position.y
	state_timer = move_time
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.stop()

func _physics_process(delta):
	if not fight_started:
		return
	
	# Update state timer
	state_timer -= delta
	
	if state_timer <= 0:
		is_moving = !is_moving
		if is_moving:
			state_timer = move_time
		else:
			state_timer = wait_time
	
	# Movement
	if is_moving:
		velocity.y = float_speed * move_direction
	else:
		velocity.y = 0
	
	velocity.x = 0
	move_and_slide()
	
	# Reverse direction at range limits
	if global_position.y > start_y + float_range:
		move_direction = -1.0
	elif global_position.y < start_y - float_range:
		move_direction = 1.0
	
	# Reverse if hitting ceiling/floor
	if is_on_floor() or is_on_ceiling():
		move_direction *= -1.0
	
	# Face the player
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		sprite.flip_h = player.global_position.x > global_position.x

func start_fight():
	print("Boss fight started!")
	fight_started = true
	shoot_timer.start()

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
	
	var direction_to_player = (player.global_position - global_position).normalized()
	
	for i in range(shots_per_attack):
		var projectile = projectile_scene.instantiate()
		projectile.position = global_position
		
		var spread = randf_range(-shot_spread, shot_spread)
		var shot_direction = direction_to_player.rotated(spread)
		projectile.direction = shot_direction
		
		get_tree().current_scene.add_child(projectile)
		
		await get_tree().create_timer(0.1).timeout

func take_damage(amount: float):
	health -= amount
	health_bar.value = health
	
	sprite.modulate = Color(1, 0.3, 0.3, 1)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)
	
	print("Boss health: ", health)
	
	if health <= 0:
		call_deferred("die")

func die():
	print("Boss defeated!")
	Global.boss_defeated.emit()
	
	var item = victory_item.instantiate()
	item.position = global_position
	item.next_level_unlock = next_level_unlock  # Pass to victory item
	get_tree().current_scene.add_child(item)
	
	queue_free()
