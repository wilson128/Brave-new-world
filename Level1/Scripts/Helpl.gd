extends Control

func _on_Help_confirmed():	
	get_node("/root/Room/YSort/Player").canMove = true
	get_node("/root/Room/YSort/Player/Camera2D/Menu").open = false
