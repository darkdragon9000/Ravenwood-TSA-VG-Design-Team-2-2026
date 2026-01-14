extends Area2D

var speed: float = 600.0
var direction: Vector2 = Vector2.RIGHT
var damage: float = 10.0

func _ready():
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _physics_process(delta):
	position += direction * speed * delta
	rotation = direction.angle()

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		body.take_damage(damage)
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("Enemy"):
		area.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
