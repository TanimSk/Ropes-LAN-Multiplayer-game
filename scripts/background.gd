extends ColorRect

#onready var audio:= get_node("Audio")
#var audio_loop:bool = true

var audio_level:int = 0
var audio_loop:bool = true
var audio

func _ready():
	play_audio("res://assets/audio/intro.wav")

func play_audio(stream) -> void:

	for _node in get_children():
		print(_node)
		_node.queue_free()

	audio = AudioStreamPlayer.new()
	audio.stream = load(stream)
	audio.set_volume_db(audio_level)
	add_child(audio)
	audio.play()
	audio.connect("finished", self, "audio_finished")

func set_volume(level) -> void:
	audio_level = level
	audio.set_volume_db(level)

func audio_finished():
	if audio_loop:
		audio.play()


#func _on_Audio_finished():
#	if audio_loop:
#		audio.play()
