extends CharacterBody2D

var SPEED = 200.0
const JUMP_VELOCITY = -500.0
const KINDNESS_SCENE = preload("res://kindness_beam.tscn")

static var flashlights_collected: int = 0
static var teddybears_collected: int = 0

@export var goal_count: int = 2
@export var is_level_2: bool = false
@export var is_level_3: bool = false

var strength = 0 
var is_winning = false 

@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.1
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

@onready var sprite = $AnimatedSprite2D

func _ready():
	add_to_group("Player")
	
	if is_level_3:
		strength = 0
		flashlights_collected = 0
		teddybears_collected = 0
		
	update_mood()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		velocity += get_gravity() * delta
		coyote_timer -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = (direction < 0)
		sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")

	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		var beam = KINDNESS_SCENE.instantiate()
		beam.direction = -1 if sprite.flip_h else 1
		beam.creator = self
		get_parent().add_child(beam)
		
		if has_node("Muzzle"):
			beam.global_position = $Muzzle.global_position
		else:
			beam.global_position = global_position

func update_mood():
	var bar = get_tree().current_scene.find_child("ProgressBar", true, false)	
	if bar:
		if is_level_3:
			bar.max_value = 150
			bar.value = strength  # Use the strength we just added +25 to!
			print("UI Updated: ", bar.value, "/150")
		else:
			bar.max_value = 150
			bar.value = strength
			print("UI UPDATED (Strength) | Value: ", bar.value)
	else:
		print("Error: ProgressBar not found in this scene!")

	if is_level_3:
		return 

	if is_level_2:
		if strength >= 150 and not is_winning:
			is_winning = true
			complete_level()
		return 

	
	print("Checking Level 1 Win: Strength=", strength, " IsWinning=", is_winning) 
	
	if strength >= 150 and not is_winning:
		is_winning = true
		complete_level()
	elif strength >= 120: SPEED = 350.0
	elif strength >= 80:  SPEED = 300.0
	elif strength >= 40:  SPEED = 250.0
	else:                SPEED = 200.0

func check_level_3_win():
	update_mood()
	
	if flashlights_collected >= 4 and teddybears_collected >= 4 and not is_winning and strength >= 150:
		is_winning = true
		print("Level 3 Victory! Proceeding to Win Cutscene...")
		complete_level()

func complete_level():
	print("Victory Sequence Started!")
	await get_tree().create_timer(0.5).timeout
	
	if is_level_3:
		Global.complete_level(3) 
		get_tree().change_scene_to_file("res://cutscenes/cutscene_child3_postscene.tscn")
		
	elif is_level_2:
		Global.complete_level(2) 
		Global.unlock_level(3)  
		get_tree().change_scene_to_file("res://cutscenes/cutscene_child2_postscene.tscn")
	else:
		# This is Level 1
		Global.complete_level(1) 
		Global.unlock_level(2)
		get_tree().change_scene_to_file("res://cutscenes/cutscene_child1_postscene.tscn")
		
func _on_void_body_entered(_body: Node2D) -> void:
	get_tree().reload_current_scene()
