extends Area2D

@export var courage_value: int = 15

func _on_body_entered(body):
	if body is CharacterBody2D:
		if "strength" in body:
			body.strength += courage_value
			body.update_mood() 
			print("Picked up a toy! Courage: ", body.strength)
			
			AudioManager.play_collect()
			
			queue_free()
