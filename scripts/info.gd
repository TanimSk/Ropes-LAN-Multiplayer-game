extends Control


func _on_mail_button_up():
	print(OS.shell_open("mailto:vertx.softwares@gmail.com"))


func _on_back_button_up():
	var options_scene:= load("res://scenes/options.tscn")
	get_tree().get_root().add_child(options_scene.instance())
	queue_free()
