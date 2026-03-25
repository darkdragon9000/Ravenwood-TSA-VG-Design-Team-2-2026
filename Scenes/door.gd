extends StaticBody2D

@onready var collision_shape_2d = $CollisionShape2D

var victory_item = preload("res://Scenes/victory_item.tscn")



func _on_door_trigger_body_entered(body):
	if body.is_in_group("Player") and Global.power >= 100:
		collision_shape_2d.set_deferred("disabled", true)
		var item = victory_item.instantiate()
		item.next_level_unlock = 3
		item.position = global_position
		get_tree().current_scene.add_child(item)
