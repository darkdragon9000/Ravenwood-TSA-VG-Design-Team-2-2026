extends Area2D

@export var power_value: float = 10

#@export var sprite_texture: Texture2D
#
#@onready var sprite = $AnimatedSprite2D
#
#func _ready():
	#body_entered.connect(_on_body_entered)
	#if sprite_texture:
		#sprite.texture = sprite_texture

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.add_power(power_value)
		AudioManager.play_collect()
		print("+" , power_value, " ", Global.get_power_name())
		queue_free()
