extends Node2D

var count:int = 0

onready var indicator = get_node("indicator")
onready var indicator_pos:float

onready var frope = get_tree().get_root().get_node("game/rope/rope1")
onready var lrope =  get_tree().get_root().get_node("game/rope/rope25")
onready var anime = get_node("AnimationPlayer")

onready var timer = get_node("Timer")
onready var time = get_node("time")

onready var global = get_tree().get_root().get_node("/root/PlayerWinner")

onready var audio = get_node("AudioStreamPlayer")

onready var server_player = get_node("player_name1") 
onready var client_player = get_node("player_name2")

onready var stat: bool = false
var speed_right: int = 10
var speed_left:int = 10

var time_ds:int = 10
var time_s:int = 40 # time in seconds

func _ready():
	anime.play("startup")
	indicator_pos = indicator.position.x
	if get_tree().is_network_server():
		stat = true
		rpc("set_nm_server", global.player_name)
	else:
		rpc("set_nm_client", global.player_name)


sync func set_vel(spr, spl):
	speed_right = spr
	speed_left = spl


sync func set_nm_client(player_name):
	client_player.text = player_name


sync func set_nm_server(player_name):
	server_player.text = player_name


sync func game_over(side):
	global.pass_string = side
	var end_screen = preload("res://assets/game/game_over/game_over.tscn").instance()
	get_tree().get_root().add_child(end_screen)
	queue_free()



func _process(_delta):
	frope.linear_velocity.y = speed_left
	lrope.linear_velocity.y = speed_right
	if abs(speed_right-speed_left) < 200:
		indicator.position.x = speed_right - speed_left + indicator_pos
	


func _on_TextureButton_pressed():
	count += 1
	if stat:					# will change later
		speed_left = count*5
	else:
		speed_right = count*5

	rpc_unreliable('set_vel', speed_right, speed_left)


func _on_detector_left_body_entered(_body):
	if stat:
		rpc('game_over', global.player_name + ' is the winner')


func _on_detector_right_body_entered(_body):
	if !stat:
		rpc('game_over', global.player_name + ' is the winner')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "startup":
		timer.start()
		audio.play()


func _on_Timer_timeout():
	if time_ds == 0:
		time_s -= 1
		time_ds = 10
	if time_s == 0 and time_ds == 10:
		timer.stop()
		rpc('game_over', 'Its a draw')
		
	time_ds -= 1
	
	time.text = str(time_s) + ' : 0' + str(time_ds)


func _on_AudioStreamPlayer_finished():
	audio.play()
