extends CharacterBody2D

# Movement
@export var speed: float = 300.0
@export var jump_force: float = -400.0
@export var gravity: float = 980.0
var facing_direction: Vector2 = Vector2.RIGHT

# Coyote Time & Jump Buffering
@export var coyote_time: float = 0.15  # Time after leaving ground you can still jump
@export var jump_buffer_time: float = 0.1  # Time before landing that jump input is remembered
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var was_on_floor: bool = false

# Shooting
var projectile_scene = preload("res://projectile.tscn")
var can_shoot: bool = true
@export var shot_cost = 10

# Invincibility
var is_invincible: bool = false

# Focus Mode
var focus_mode: bool = false
@export var focus_drain: float = 10.0
var focus_time_scale: float = 0.5

# Nodes
@onready var sprite = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var invincible_timer = $InvincibleTimer

func _ready():
	add_to_group("Player")
	
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	invincible_timer.timeout.connect(_on_invincible_timer_timeout)
	invincible_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	Global.player_died.connect(die)

func _physics_process(delta):
	# Focus mode
	handle_focus_mode(delta)
	
	# Handle coyote time
	if is_on_floor():
		coyote_timer = coyote_time
		was_on_floor = true
	else:
		if was_on_floor:
			# Just left the ground, start coyote timer
			was_on_floor = false
		coyote_timer -= delta
	
	# Handle jump buffer
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Jump - check coyote time and jump buffer
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = jump_force
		jump_buffer_timer = 0.0  # Clear buffer
		coyote_timer = 0.0  # Clear coyote time
	
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

func handle_focus_mode(delta):
	if Input.is_action_pressed("focus") and Global.power > 0:
		if not focus_mode:
			focus_mode = true
			Engine.time_scale = focus_time_scale
			sprite.modulate = Color(0.6, 0.8, 1, 1)
			print("Focus mode ON")
		var real_delta = delta / Engine.time_scale
		Global.add_power(-focus_drain * real_delta)
	else:
		if focus_mode:
			focus_mode = false
			Engine.time_scale = 1.0
			sprite.modulate = Color(1, 1, 1, 1)
			print("Focus mode OFF")

func shoot():
	if Global.power < 10:
		return
	
	can_shoot = false
	shoot_timer.start()
	
	Global.add_power(shot_cost)
	
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
	if not focus_mode:
		sprite.modulate = Color(1, 1, 1, 1)
	else:
		sprite.modulate = Color(0.6, 0.8, 1, 1)

func die():
	print("Game Over!")
	Engine.time_scale = 0.5
	$CollisionShape2D.queue_free()
	await get_tree().create_timer(0.5).timeout
	Engine.time_scale = 1.0
	Global.reset_stats()
	Global.current_level = 1
	get_tree().reload_current_scene()
