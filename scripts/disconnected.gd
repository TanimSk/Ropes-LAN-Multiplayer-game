extends Control

onready var background:= get_tree().get_root().get_node("/root/Background")
#onready var audio:= get_tree().get_root().get_node("/root/Background/Audio")

func _ready():
	$AnimationPlayer.play("text")

func _on_home_btn_button_up():
	background.audio_loop = true
	background.play_audio("res://assets/audio/intro.wav")
	var mainMenu:= load("res://scenes/MainMenu.tscn")
	get_tree().get_root().add_child(mainMenu.instance())
	queue_free()
