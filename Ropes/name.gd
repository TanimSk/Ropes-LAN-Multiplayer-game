extends TextEdit

onready var done_btn = get_tree().get_root().get_node("/root/first_page/first_time/done_btn")
onready var this = get_node(".")

var pos_y:float
var pos_stat:int = 3

func _ready():
	pos_y = this.rect_position.y
	this.text = "Your Name"


func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		done_btn.emit_signal("pressed")
		done_btn.grab_focus()


func _process(delta):
	if this.rect_position.y < pos_y - 200 and pos_stat == 0:
		pos_stat = 3
		this.text = ""
	
	if pos_stat == 0:
		this.rect_position.y -= 1000*delta

func _on_name_focus_entered():
	pos_stat = 0
