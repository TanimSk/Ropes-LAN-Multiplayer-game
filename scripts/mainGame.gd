extends "res://scripts/disconnected_stat.gd"

onready var rope1:= get_node("Game/rope/rope1")
onready var rope2:=  get_node("Game/rope/rope25")
onready var curtain:= get_node("curtain")
onready var anim:= get_node("AnimationPlayer")
onready var timer:= get_node("Timer")
onready var indicator:= get_node("progress/indicator")

func _ready():
	curtain.show()
	anim.play("countdown")
	var imageTexture = ImageTexture.new()
	var newImage = Image.new()
	newImage.create(get_viewport().size.x*2,  get_viewport().size.y*2, false, Image.FORMAT_RGB8)
	newImage.fill(background.get_frame_color())
	imageTexture.create_from_image(newImage)	
	$Light2D.set_texture(imageTexture) 
	rpc("set_name", global.saved_data.name)


sync func set_name(player_name):
	if global.is_host:
		if global.saved_data.name != "":
			$player_name2/name.text = global.saved_data.name
		if player_name != "":
			$player_name1/name.text = player_name
	
	else:
		if global.saved_data.name != "":
			$player_name1/name.text = global.saved_data.name
		if player_name != "":
			$player_name2/name.text = player_name

var first_pull:bool = false

func _on_push_pressed():
	if not first_pull:
		if global.is_host:
			rpc("f_pull", 2)
		else:
			rpc("f_pull", 1)
		first_pull = true

	rpc("rope_pulled", global.is_host)


sync func f_pull(num):
	if num == 1:
		$Game/Player1/sprite.play("pulling")
	else:
		$Game/Player2/sprite.play("pulling")


var client_power:int = 0
var host_power:int = 0
var resultant:int = 0

sync func rope_pulled(is_host):
	if is_host:
		host_power += 6
		if indicator.rect_position.x < 295:
			indicator.rect_position.x += host_power*0.075
	else:
		client_power += 6
		if indicator.rect_position.x > 15:
			indicator.rect_position.x -= client_power*0.075
		
	resultant = host_power - client_power
	
	if resultant > 0:
		rope2.set_gravity_scale(resultant + 0.5)
		
	elif resultant < 0:
		rope1.set_gravity_scale(abs(resultant) + 0.5)

	else:
		rope1.set_gravity_scale(1.5)
		rope2.set_gravity_scale(1.5)



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "countdown":
		curtain.queue_free()
		background.audio_loop = true
		background.play_audio("res://assets/audio/game_play.wav")
		timer.start()

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "countdown":
		background.audio_loop = false
		background.play_audio("res://assets/audio/countdown.wav")

var f_time_collide:bool = false

func _on_area1_body_entered(_body): # client winner
	if not f_time_collide:
		rpc("client_winner")

func _on_area2_body_entered(_body): # host winner
	if not f_time_collide:
		rpc("host_winner")

sync func client_winner():
	$Game/Player1/sprite.play("victory")
	$Game/Player2/sprite.play("loser")
	$result.show()
	var audio_location
	if global.is_host:
		audio_location = "res://assets/audio/loser.wav"
		$result.text = global.saved_data.name + "\n you are weak !"
		global.result = "loss"
	else:
		audio_location = "res://assets/audio/victory.wav"
		$result.text = global.saved_data.name + "\n you are strong !"
		global.result = "win"
		
	background.audio_loop = false
	background.play_audio(audio_location)
	f_time_collide = true
	$wait.start()
	$Timer.stop()
	$Game/Player1/StaticBody2D.position.y += 500
	$Game/Player2/StaticBody2D.position.y += 500

sync func host_winner():
	$Game/Player2/sprite.play("victory")
	$Game/Player1/sprite.play("loser")
	$result.show()
	var audio_location
	if not global.is_host:
		audio_location = "res://assets/audio/loser.wav"
		$result.text = global.saved_data.name + "\n you are weak !"
		global.result = "loss"
	else:
		audio_location = "res://assets/audio/victory.wav"
		$result.text = global.saved_data.name + "\n you are strong !"
		global.result = "win"

	background.audio_loop = false
	background.play_audio(audio_location)
	f_time_collide = true
	$wait.start()
	$Timer.stop()
	$Game/Player1/StaticBody2D.position.y += 500
	$Game/Player2/StaticBody2D.position.y += 500

func _on_wait_timeout():
	var gameOver:= load("res://scenes/start_scene/game_over.tscn")
	get_tree().get_root().add_child(gameOver.instance())
	queue_free()

