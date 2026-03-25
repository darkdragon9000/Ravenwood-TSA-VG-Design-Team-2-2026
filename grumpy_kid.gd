extends Area2D

@export var drain_amount = 20 
var can_drain = true # Consistent name

@export var walk_distance: float = 60.0 
@export var walk_speed: float = 50.0
var start_x: float # We only need the X coordinate for side-to-side
var direction: int = 1 

func _ready():
	# Store the starting X position
	start_x = global_position.x

func _process(delta):
	global_position.x += walk_speed * direction * delta
	
	if global_position.x > start_x + walk_distance:
		direction = -1
		$Sprite2D.flip_h = true
	elif global_position.x < start_x - walk_distance:
		direction = 1
		$Sprite2D.flip_h = false

func _on_body_entered(body):
	if body.is_in_group("Player") and can_drain:
		steal_courage(body)
		AudioManager.play_damage()

func steal_courage(player):
	can_drain = false
	
	var knockback_dir = (player.global_position - global_position).normalized()
	player.velocity = knockback_dir * 500
	
	player.strength -= drain_amount
	if player.strength < 0:
		player.strength = 0
	
	player.update_mood()
	
	player.modulate = Color(1, 0, 0)
	
	await get_tree().create_timer(1.0).timeout
	player.modulate = Color(1, 1, 1) 
	can_drain = true
