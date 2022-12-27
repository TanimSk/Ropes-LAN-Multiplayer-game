extends Control

var toggled:bool = false

onready var background:= get_tree().get_root().get_node("/root/Background")
#onready var audio:= get_tree().get_root().get_node("/root/Background/Audio")
onready var global:= get_tree().get_root().get_node("/root/Global")

onready var player_name:= get_node("Player_name")
onready var sound_level:= get_node("sound/HSlider")
onready var sound_btn:= get_node("sound/sound")
onready var change_bg:= get_node("change_bg_layer")

func _ready():
	player_name.text = global.saved_data.name
	sound_level.value = global.saved_data.sound_level
	
	if global.saved_data.muted:
		toggled = true
		
	if player_name.text == "":
		player_name.grab_focus()
		
	if global.saved_data.muted:
		sound_btn.pressed = true


func _on_sound_button_up():
	toggled = !toggled
	if toggled:
		print("muted")
		background.set_volume(-80)
		global.saved_data.muted = true
	else:
		print("unmuted")
		global.saved_data.muted = false
		background.set_volume(
			((35*global.saved_data.sound_level)/100) - 30
		)

func _on_HSlider_value_changed(value):
	if not global.saved_data.muted:
		background.set_volume(
			((35*global.saved_data.sound_level)/100) - 30
		)
	global.saved_data.sound_level = value


func _on_back_button_up():
	global.saved_data.name = player_name.text
	
	var file = File.new()
	file.open("user://user.dat", File.WRITE)
	file.store_var(global.saved_data)
	file.close()

	var mainMenu_scene:= load("res://scenes/MainMenu.tscn")
	get_tree().get_root().add_child(mainMenu_scene.instance())
	queue_free()


func _on_change_bg_button_up():
	change_bg.show()

func _on_confirm_button_up():
	global.saved_data.bg_color = background.color
	
	var file = File.new()
	file.open("user://user.dat", File.WRITE)
	file.store_var(global.saved_data)
	file.close()

	change_bg.hide()


func _on_info_button_up():
	var infoScene:= load("res://scenes/info.tscn")
	get_tree().get_root().add_child(infoScene.instance())
	queue_free()




######### COLOR #########

func _on_white_pressed():
	background.color = Color("e8e8e8")


func _on_green_pressed():
	background.color = Color("9ae1a4")


func _on_red_pressed():
	background.color = Color("fcbbbb")


func _on_yellow_pressed():
	background.color = Color("fcf7bb")


func _on_purple_pressed():
	background.color = Color("d9bbfc")
