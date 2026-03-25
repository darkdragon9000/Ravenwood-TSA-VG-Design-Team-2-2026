extends Area2D
@export var walk_distance: float = 70.0 
@export var walk_speed: float = 50.0

var start_position: Vector2
var direction: int = 1 
@export var drain_amount: int = 20 

func _on_body_entered(body: Node2D) -> void:
	print("Ouch! I hit something named: ", body.name)
	if body is CharacterBody2D:
		AudioManager.play_damage()
		body.modulate = Color(1, 0, 0) 
		await get_tree().create_timer(0.2).timeout
		
		if body != null: 
			body.modulate = Color.WHITE
		body.strength -= 20
		
		if body.has_method("update_mood"):
			body.update_mood()
		if body.strength <= 0:
			get_tree().reload_current_scene()
			return 
			
func _ready():
	start_position = global_position

func _process(delta):
	position.x += walk_speed * direction * delta
	
	if position.x > start_position.x + walk_distance:
		direction = -1 
		$Sprite2D.flip_h = false
		
	if position.x < start_position.x - walk_distance:
		direction = 1 
		$Sprite2D.flip_h = true 
