extends Area2D

@export var boss: CharacterBody2D  # Drag your boss node here in inspector

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		boss.start_fight()
		queue_free()  # Remove trigger after activating extends Area2D
