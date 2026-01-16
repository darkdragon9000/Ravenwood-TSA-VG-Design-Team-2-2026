extends Area2D

@onready var timer = $Timer

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("U Dead")
		AudioManager.play_damage()
		Engine.time_scale = 0.5
		body.get_node("CollisionShape2D").queue_free()
		timer.start()
	


func _on_timer_timeout():
	Engine.time_scale = 1.0
	Global.reset_stats()
	get_tree().reload_current_scene()
	print("Resetting")
