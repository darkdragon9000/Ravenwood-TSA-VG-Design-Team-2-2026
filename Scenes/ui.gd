extends CanvasLayer

@onready var power_bar = $PowerBar
@onready var power_label = $PowerLabel
@onready var health_bar = $VBoxContainer/HealthBar

func _ready():
	# Connect to global signals
	Global.power_changed.connect(_on_power_changed)
	Global.health_changed.connect(_on_health_changed)
	
	# Initialize bars
	power_bar.max_value = Global.max_power
	power_bar.value = Global.power
	health_bar.max_value = Global.max_health
	health_bar.value = Global.health
	
	# Set label to match current level
	power_label.text = Global.get_power_name() + ":"

func _on_power_changed(new_value):
	power_bar.value = new_value

func _on_health_changed(new_value):
	health_bar.value = new_value
