extends Node2D

onready var winner = get_node("winner")
onready var global = get_tree().get_root().get_node("/root/PlayerWinner")
onready var exit = get_node("exit_btn")

onready var scrn_size = get_viewport().size

func _ready():
	exit.rect_position.x = scrn_size.x - 135
	exit.rect_position.y = scrn_size.y - 140
	winner.text = global.pass_string
	global.pass_string = ""


sync func restart():
	get_tree().change_scene("res://assets/game/game.tscn")


func _on_restart_pressed():
	rpc("restart")


func _on_exit_btn_button_up():
	rpc("exit_game")

sync func exit_game():
	get_tree().quit()
