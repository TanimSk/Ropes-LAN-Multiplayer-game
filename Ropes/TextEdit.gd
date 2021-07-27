extends TextEdit

onready var start_btn = get_tree().get_root().get_node("/root/Control/join_page/start")
onready var this = get_node(".")

var pos_y:float
var pos_stat:int = 3

func _ready():
	pos_y = this.rect_position.y
	this.text = "Enter the ID"


func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		start_btn.emit_signal("pressed")
		start_btn.grab_focus()


func _process(delta):
	if this.rect_position.y < pos_y - 900 and pos_stat == 0:
		pos_stat = 3
		this.text = ""
	
	if pos_stat == 0:
		this.rect_position.y -= 1000*delta

func _on_TextEdit_focus_entered():
	pos_stat = 0

