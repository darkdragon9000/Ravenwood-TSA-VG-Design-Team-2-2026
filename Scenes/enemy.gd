extends CharacterBody2D

@export var speed: float = 50.0
var gravity: float = 980.0
var direction: float = -1.0

var collectible_scene = preload("res://Scenes/collectible.tscn")
@export var drop_value: float = 20.0

var is_dead: bool = false

@onready var sprite = $Sprite2D
@onready var hitbox = $HitboxArea

func _ready():
	add_to_group("Enemy")
	hitbox.body_entered.connect(_on_hitbox_entered)

func _physics_process(delta):
	if is_dead:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = speed * direction
	
	move_and_slide()
	
	if is_on_wall():
		direction *= -1.0
	
	sprite.flip_h = direction > 0
	#sprite.play("walk")

func _on_hitbox_entered(body):
	if is_dead:
		return
	
	if body.is_in_group("Player"):
		# Check if player is above enemy and falling down
		var player_feet = body.global_position.y + 30  # Adjust based on player size
		var enemy_top = global_position.y - 20  # Adjust based on enemy size
		
		if body.velocity.y > 0 and player_feet < enemy_top:
			# Player stomped enemy
			body.velocity.y = -300.0
			call_deferred("die")
		else:
			# Player touched enemy from side/below
			body.take_damage(20.0)

func take_damage(amount: float):
	if is_dead:
		return
	call_deferred("die")

func die():
	if is_dead:
		return
	
	is_dead = true
	
	# Drop collectible
	var orb = collectible_scene.instantiate()
	orb.position = global_position 
	orb.power_value = drop_value
	get_tree().current_scene.add_child(orb)
	
	queue_free()
