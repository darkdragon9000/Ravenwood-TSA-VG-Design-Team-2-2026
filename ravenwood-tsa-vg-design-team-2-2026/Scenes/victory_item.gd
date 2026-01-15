extends Area2D

@export var next_level_unlock: int = 2
var float_offset: float = 0.0

@onready var sprite = $AnimatedSprite2D
var start_y: float

func _ready():
	body_entered.connect(_on_body_entered)
	start_y = position.y

func _process(delta):
	#Floating animation
	float_offset += delta * 3.0
	position.y = start_y + sin(float_offset) * 5.0
	


func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Level Complete! Unlocked level ", next_level_unlock)
		
		# Unlock next level
		Global.unlock_level(next_level_unlock)
		
		# Go to level select
		Global.go_to_level_select()
