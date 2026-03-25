extends CharacterBody2D

var speed = 50.0
var direction = 1 # 1 is Right, -1 is Left
@export var float_amplitude: float = 20.0 
@export var float_speed: float = 3.0     

var start_y: float
func _on_body_entered(body: Node2D) -> void:
	# Use "is CharacterBody2D" to be safe since you reset
	if body is CharacterBody2D:
		body.strength += 5
		body.update_mood()
		print("Friend collected! Strength is now: ", body.strength)
		queue_free()

func _ready():
	# This ensures we grab the position BEFORE any processing happens
	start_y = position.y

func _process(delta):
	# We use 'Time.get_ticks_msec()' because it never resets
	var time = Time.get_ticks_msec() / 1000.0
	var offset = sin(time * float_speed) * float_amplitude
	
	# Force the position
	position.y = start_y + offset
