extends "res://scripts/disconnected_stat.gd"

onready var stat:= $stat
onready var btn_text:= get_node("restart/text")
onready var emo:= $emoji

func _ready():
	if global.rematch_count == 3:
		print("ads")
		$AdMob.load_rewarded_video()
		$AdMob.show_rewarded_video()
		global.rematch_count = 0

	if global.result == "win":
		win()
	elif global.result == "loss":
		loss()
	elif global.result == "draw":
		draw()

func draw():
	background.audio_loop = false
	background.play_audio("res://assets/audio/draw.wav")
	stat.text = "Its a draw !\n lets try again"
	emo.set_texture(
		load("res://assets/images/neutral.png")
	)

func loss():
	stat.text = "You lost! \n try again, Dont give up"
	btn_text.text = "Rematch"
	emo.set_texture(
		load("res://assets/images/sad.png")
	)

func win():
	stat.text = "You win! \n Congrats yaay!"
	btn_text.text = "Rematch"
	emo.set_texture(
		load("res://assets/images/win.png")
	)

func _on_back_button_up():
	rpc("main_menu")

func _on_restart_button_up():
	rpc("rematch")

sync func rematch():
	var mainGame:= load("res://scenes/start_scene/mainGame.tscn")
	global.rematch_count += 1
	
	get_tree().get_root().add_child(mainGame.instance())
	queue_free()

sync func main_menu():
	background.audio_loop = true
	background.play_audio("res://assets/audio/intro.wav")
	var mainMenu:= load("res://scenes/MainMenu.tscn")
	get_tree().get_root().add_child(mainMenu.instance())
	queue_free()


func _on_AdMob_interstitial_failed_to_load(error_code):
	print(error_code)
