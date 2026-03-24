extends Area2D

@export var min_bounce: float = -400.0  # Bounce with no power
@export var max_bounce: float = -700.0  # Bounce with full power
@export var power_for_max: float = 50.0  # Power needed for max bounce

@onready var sprite = $AnimatedSprite2D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	# Visual feedback - brighter when player has more power
	var power_ratio = clamp(Global.power / power_for_max, 0.2, 1.0)
	sprite.modulate = Color(1, power_ratio, power_ratio, 1)  # Gets brighter with power

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# More power = higher jump
		var power_ratio = clamp(Global.power / power_for_max, 0.2, 1.0)
		var bounce_force = lerpf(min_bounce, max_bounce, power_ratio)
		body.velocity.y = bounce_force
		
		# Optional: small power cost
		# Global.add_power(-5.0)
		
		print("Bounce! Power: ", Global.power, " Force: ", bounce_force)
