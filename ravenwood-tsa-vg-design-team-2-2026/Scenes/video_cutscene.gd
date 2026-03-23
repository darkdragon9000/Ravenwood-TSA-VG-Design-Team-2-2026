extends Control

@export_file("*.ogv") var video_path: String = ""
@export var next_scene: String = ""

@onready var video_player = $VideoStreamPlayer

func _ready():
	# Load and play video
	if video_path != "":
		var video_stream = load(video_path)
		video_player.stream = video_stream
		video_player.play()
	
	# Connect finished signal
	video_player.finished.connect(_on_video_finished)
	
	


func _input(event):
	if event.is_action_pressed("jump") or event.is_action_pressed("shoot"):
		skip_video()

func skip_video():
	video_player.stop()
	go_to_next_scene()

func _on_video_finished():
	go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene_to_file(next_scene)
