extends Area2D

var is_happy = false
@export var happiness_boost = 50 
@export var happy_sprite: Texture2D 

func get_happy(giver):
	if not is_happy:
		is_happy = true
		
		if happy_sprite:
			print("Attempting to change sprite to Happy Texture!")
			$Sprite2D.texture = happy_sprite
			AudioManager.play_collect()
		else:
			print("Error: No Happy Sprite assigned in the Inspector!")

		modulate = Color(1, 1, 1) 
		
		if giver != null:
			giver.strength += happiness_boost
			giver.update_mood()
