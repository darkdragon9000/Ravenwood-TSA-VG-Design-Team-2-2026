extends CharacterBody2D

# Movement
@export var speed: float = 300.0
@export var jump_force: float = -400.0
@export var gravity: float = 980.0
var facing_direction: Vector2 = Vector2.RIGHT  # Track which way player faces

# Shooting
var projectile_scene = preload("res://projectile.tscn")
var can_shoot: bool = true

# Invincibility
var is_invincible: bool = false

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var invincible_timer = $InvincibleTimer

func _ready():
	add_to_group("Player")
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	invincible_timer.timeout.connect(_on_invincible_timer_timeout)
	Global.player_died.connect(die)

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	
	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	# Flip sprite and update facing direction
	if direction > 0:
		sprite.flip_h = false
		facing_direction = Vector2.RIGHT
	elif direction < 0:
		sprite.flip_h = true
		facing_direction = Vector2.LEFT
	
	move_and_slide()
	
	# Shooting with Z key
	if Input.is_action_just_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	# Check if player has enough power
	if Global.power < 10:
		return  # Can't shoot without power
	
	can_shoot = false
	shoot_timer.start()
	
	# Use 10 power per shot
	Global.add_power(-10)
	
	var projectile = projectile_scene.instantiate()
	projectile.position = global_position
	projectile.direction = facing_direction
	get_tree().current_scene.add_child(projectile)

func _on_shoot_timer_timeout():
	can_shoot = true

func take_damage(amount: float):
	if is_invincible:
		return
	
	Global.take_damage(amount)
	
	is_invincible = true
	invincible_timer.start()
	sprite.modulate = Color(1, 0.3, 0.3, 0.7)

func _on_invincible_timer_timeout():
	is_invincible = false
	sprite.modulate = Color(1, 1, 1, 1)

func die():
	print("Game Over!")
	Engine.time_scale = 0.5
	$CollisionShape2D.queue_free()
	await get_tree().create_timer(0.5).timeout
	Engine.time_scale = 1.0
	Global.reset_stats()
	Global.current_level = 1
	get_tree().reload_current_scene()
