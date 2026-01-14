extends Control


@onready var level_select_button = $VBoxContainer/LevelSelectButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	level_select_button.pressed.connect(_on_level_select_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://menus/level_select.tscn")

func _on_quit_pressed():
	get_tree().quit()
