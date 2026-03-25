extends Area2D

var speed = 400
var direction = 1 # 1 for right, -1 for left

func _process(delta):
	position.x += speed * direction * delta

func _on_body_entered(body):
	if body.is_in_group("SadKids"):
		body.cheer_up() # We will make this function next!
		queue_free() # The toy disappears after being shared
