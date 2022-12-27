extends Timer

onready var timer:= get_parent().get_node("timer")
onready var global:= get_tree().get_root().get_node("/root/Global")

var sec:int = 40
var msec:int = 0

func _ready():
	timer.text = zfill(sec) + ":" + zfill(msec)

func _on_Timer_timeout():
	if msec == 0:
		msec = 9
		sec -= 1
		
	msec -= 1
	timer.text = zfill(sec) + ":" + zfill(msec)
	
	if sec == 0 and msec == 0:
		rpc("game_over")

func zfill(number) -> String:
	if number <= 9:
		return ('0' + str(number))
	else:
		return str(number)

sync func game_over():
	stop()
	global.result = "draw"
	var gameOver:= load("res://scenes/start_scene/game_over.tscn")
	get_tree().get_root().add_child(
		gameOver.instance()
	)
	get_parent().queue_free()
