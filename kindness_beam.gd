extends Area2D

var speed = 450
var velocity = Vector2.ZERO
var direction = 1
var angle_vertical = -0.1
var creator 

func _ready():
	velocity = Vector2(direction, angle_vertical).normalized() * speed
	
	var overlapping_areas = get_overlapping_areas()
	for area in overlapping_areas:
		if area.has_method("get_happy"):
			area.get_happy(creator)
			queue_free()

func _process(delta):
	position += velocity * delta

func _on_area_entered(area):
	if area.has_method("get_happy"):
		area.get_happy(creator)
		queue_free()
	elif area is StaticBody2D:
		queue_free()
