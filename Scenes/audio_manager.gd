extends Node

# Music player
var music_player: AudioStreamPlayer

# Multiple SFX players for layering
var sfx_player: AudioStreamPlayer
var voice_player: AudioStreamPlayer

# Music tracks (add when you have them)
var menu_music: AudioStream = null
var level1_music: AudioStream = null
var level2_music: AudioStream = null
var level3_music: AudioStream = null
var boss_music: AudioStream = null

# Sound effects
var damage_sfx = preload("res://audio/sfx/hurt.wav")
var collect_sfx = preload("res://audio/sfx/coin.wav")

# Damage/Death voice lines (randomly picked)
var damage_voices: Array = [
	preload("res://audio/sfx/benny_nooooo.mp3"),
	preload("res://audio/sfx/benny_ouch.mp3"),
	preload("res://audio/sfx/benny_ack.mp3"),
	preload("res://audio/sfx/benny_oof.mp3"),
	preload("res://audio/sfx/benny_ahh.mp3")
]

# Collectible voice lines (randomly picked)
var collect_voices: Array = [
	preload("res://audio/sfx/benny_yippee.mp3"),
	preload("res://audio/sfx/benny_oh_yeah.mp3")
]

# Boss milestone sound
var boss_half_health_voice = preload("res://audio/sfx/benny_acing_this.mp3")

func _ready():
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Create SFX player (for sound effects)
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)
	
	# Create voice player (for voice lines)
	voice_player = AudioStreamPlayer.new()
	voice_player.bus = "SFX"
	add_child(voice_player)

func play_music(track: AudioStream, fade_in: bool = true):
	if track == null:
		return
	if music_player.stream == track and music_player.playing:
		return
	
	if fade_in:
		music_player.volume_db = -40
		music_player.stream = track
		music_player.play()
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", 0, 1.0)
	else:
		music_player.stream = track
		music_player.volume_db = 0
		music_player.play()

func stop_music(fade_out: bool = true):
	if fade_out:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40, 1.0)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()

func play_sfx(sound: AudioStream, volume: float = 0.0):
	if sound == null:
		return
	sfx_player.stream = sound
	sfx_player.volume_db = volume
	sfx_player.play()

func play_voice(sound: AudioStream, volume: float = 0.0):
	if sound == null:
		return
	voice_player.stream = sound
	voice_player.volume_db = volume
	voice_player.play()

func play_random_voice(sounds: Array, volume: float = 0.0):
	if sounds.size() == 0:
		return
	var sound = sounds.pick_random()
	play_voice(sound, volume)

# Specific sound functions
func play_damage():
	play_sfx(damage_sfx)  # Sound effect
	play_random_voice(damage_voices)  # Voice line

func play_collect():
	play_sfx(collect_sfx)  # Sound effect
	play_random_voice(collect_voices)  # Voice line

func play_boss_half_health():
	play_voice(boss_half_health_voice)

func play_menu_music():
	play_music(menu_music)

func play_level_music(level: int):
	match level:
		1:
			play_music(level1_music)
		2:
			play_music(level2_music)
		3:
			play_music(level3_music)

func play_boss_music():
	play_music(boss_music)
