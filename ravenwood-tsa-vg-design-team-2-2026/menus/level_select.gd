extends Control

@onready var level1_btn = $Level1Button
@onready var level2_btn = $Level2Button
@onready var level3_btn = $Level3Button
@onready var back_btn = $BackButton

var level_scenes = {
	1: "res://levels/level_1.tscn",
	2: "res://levels/level_2.tscn",
	3: "res://levels/level_3.tscn"
}

func _ready():
	level1_btn.pressed.connect(func(): load_level(1))
	level2_btn.pressed.connect(func(): load_level(2))
	level3_btn.pressed.connect(func(): load_level(3))
	back_btn.pressed.connect(_on_back_pressed)
	
	update_button_states()

func update_button_states():
	# Level 1 always available
	level1_btn.disabled = false
	level1_btn.text = "Level 1\nTest"
	
	# Level 2
	if Global.is_level_unlocked(2):
		level2_btn.disabled = false
		level2_btn.text = "Level 2\nCafeteria"
	else:
		level2_btn.disabled = true
		level2_btn.text = "Level 2\n🔒"
	
	# Level 3
	if Global.is_level_unlocked(3):
		level3_btn.disabled = false
		level3_btn.text = "Level 3\nProcrastination"
	else:
		level3_btn.disabled = true
		level3_btn.text = "Level 3\n🔒"

func load_level(level_num: int):
	if Global.is_level_unlocked(level_num):
		Global.current_level = level_num
		Global.reset_stats()
		get_tree().change_scene_to_file(level_scenes[level_num])

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
