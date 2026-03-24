extends Control

@onready var level1_btn = $Level1Button
@onready var level2_btn = $Level2Button
@onready var level3_btn = $Level3Button
@onready var back_btn = $BackButton
@onready var all_complete_label = $AllCompleteLabel

var level_cutscenes = {
	1: "res://cutscenes/cutscene_level1.tscn",
	2: "res://cutscenes/cutscene_level2.tscn",
	3: "res://cutscenes/cutscene_level3.tscn"
}
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
	# Level 1
	level1_btn.disabled = false
	if Global.is_level_completed(1):
		level1_btn.text = "Level 1\nTest\n✓ Complete"
	else:
		level1_btn.text = "Level 1\nTest"
	
	# Level 2
	if Global.is_level_unlocked(2):
		level2_btn.disabled = false
		if Global.is_level_completed(2):
			level2_btn.text = "Level 2\nCafeteria\n✓ Complete"
		else:
			level2_btn.text = "Level 2\nCafeteria"
	else:
		level2_btn.disabled = true
		level2_btn.text = "Level 2\n🔒"
	
	# Level 3
	if Global.is_level_unlocked(3):
		level3_btn.disabled = false
		if Global.is_level_completed(3):
			level3_btn.text = "Level 3\nProcrastination\n✓ Complete"
		else:
			level3_btn.text = "Level 3\nProcrastination"
	else:
		level3_btn.disabled = true
		level3_btn.text = "Level 3\n🔒"

func load_level(level_num: int):
	if Global.is_level_unlocked(level_num):
		Global.current_level = level_num
		Global.reset_stats()
		
		# Skip cutscene if already completed
		if Global.is_level_completed(level_num):
			get_tree().change_scene_to_file(level_scenes[level_num])
		else:
			get_tree().change_scene_to_file(level_cutscenes[level_num])

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")
func check_all_complete():
	if Global.is_level_completed(1) and Global.is_level_completed(2) and Global.is_level_completed(3):
		all_complete_label.visible = true
		all_complete_label.text = "Section 1 Complete!"
