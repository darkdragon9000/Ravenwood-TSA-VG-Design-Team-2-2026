extends CharacterBody2D

# Stats
@export var max_health: float = 100.0
@export var damage_per_hit: float = 10.0
var health: float

# Movement - vertical only
@export var float_speed: float = 50.0
@export var float_range: float = 100.0
var start_y: float
var move_direction: float = 1.0

# Move/Wait pattern
var is_moving: bool = true
@export var move_time: float = 2.0  # How long to move
@export var wait_time: float = 1.0  # How long to wait
var state_timer: float = 0.0

# Attack
var projectile_scene = preload("res://enemy_projectile.tscn")
@export var shots_per_attack: int = 3
@export var shot_spread: float = 0.3

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var health_bar = $HealthBar

# Item to drop
var victory_item_scene = preload("res://victory_item.tscn")

func _ready():
	add_to_group("Enemy")
	
	health = max_health
	health_bar.max_value = max_health
	health_bar.value = health
	
	start_y = global_position.y
	state_timer = move_time
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(delta):
	# Update state timer
	state_timer -= delta
	
	if state_timer <= 0:
		# Switch between moving and waiting
		is_moving = !is_moving
		if is_moving:
			state_timer = move_time
		else:
			state_timer = wait_time
	
	# Movement
	#if is_moving:
		#velocity.y = float_speed * move_direction
		#sprite.play("move")
	#else:
		#velocity.y = 0
		#sprite.play("idle")
	
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

func _on_shoot_timer_timeout():
	shoot()

func shoot():
	#sprite.play("attack")
	
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
		die()

func die():
	print("Boss defeated!")
	Global.boss_defeated.emit()
	
	var item = victory_item_scene.instantiate()
	item.position = global_position
	get_tree().current_scene.add_child(item)
	
	queue_free()
