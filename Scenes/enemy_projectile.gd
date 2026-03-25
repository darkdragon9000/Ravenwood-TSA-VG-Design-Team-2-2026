extends Area2D

@export var speed: float = 300.0
@export var damage: float = 20.0

var direction: Vector2 = Vector2.LEFT

@onready var sprite = $Sprite2D

func _ready():
	#body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(_on_screen_exited)

func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(damage)
		queue_free()

func _on_screen_exited():
	queue_free()
