extends Node

# Player stats
var power: float = 0.0
var max_power: float = 100.0
var health: float = 100.0
var max_health: float = 100.0

# Level info
var current_level: int = 1
var level_names = {
	1: "Focus",
	2: "Confidence", 
	3: "Motivation"
}

# Level unlocks and completion
var unlocked_levels: Array = [1]
var completed_levels: Array = []  # NEW

signal power_changed(new_value)
signal health_changed(new_value)
signal player_died
signal boss_defeated

func add_power(amount: float):
	power = clamp(power + amount, 0, max_power)
	power_changed.emit(power)

func take_damage(amount: float):
	health = clamp(health - amount, 0, max_health)
	health_changed.emit(health)
	
	if health <= 0:
		player_died.emit()

func reset_stats():
	power = 0.0
	health = max_health

func get_power_name() -> String:
	return level_names.get(current_level, "Power")

func unlock_level(level_num: int):
	if level_num not in unlocked_levels:
		unlocked_levels.append(level_num)

func complete_level(level_num: int):  # NEW
	if level_num not in completed_levels:
		completed_levels.append(level_num)

func is_level_unlocked(level_num: int) -> bool:
	return level_num in unlocked_levels

func is_level_completed(level_num: int) -> bool:  
	return level_num in completed_levels

func go_to_level_select():
	reset_stats()
	get_tree().change_scene_to_file("res://menus/level_select.tscn")

func go_to_main_menu():
	reset_stats()
	get_tree().change_scene_to_file("res://menus/main_menu.tscn")

func go_to_game_over():
	get_tree().change_scene_to_file("res://menus/game_over.tscn")
