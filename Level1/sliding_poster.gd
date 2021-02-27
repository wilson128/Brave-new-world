extends Node2D

# set up the reset button
export (NodePath) var button_path
onready var button = get_node("Reset")

var img_node = load("poster.tscn")
var img = []
var move = Vector2.ZERO
var speed = 6
var map = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11]]
var conversion_map = [10, 8, 4, 0, 7, 1, 9, 3, 6, 2, 5, 11]
var ans = [[120, 360], [240, 240],[120, 120],[0, 0],
		   [120, 240], [120, 0],[0, 360],[0, 120],
		   [0, 240], [240, 0],[240, 120],[240, 360]]
onready var pop_up = get_node("Popup/PopupPanel")

var showing = false

var counter = 0

func _ready():
	button.connect("pressed", self, "reset")
	for n in range(12):
		img.append(img_node.instance())
		img[n].set_frame(conversion_map[n])
		add_child(img[n])
		for y in range(4):
			if map[y].find(n) != -1:
				img[n].position = Vector2(map[y].find(n)*120, y*120)
	img[11].visible = false
	set_physics_process(true)

func move(dir):
	for y in range(4):
			if map[y].find(11) != -1:
				var pos = Vector2(y, map[y].find(11)) + dir
				pos.x = min(max(pos.x, 0), 3)
				pos.y = min(max(pos.y, 0), 2)
				img[map[y][map[y].find(11)]].position = Vector2(pos.y*120, pos.x*120)
				if img[map[pos.x][pos.y]].position != Vector2(map[y].find(11)*120, y*120):
					move = dir
					img[map[pos.x][pos.y]].position = img[map[pos.x][pos.y]].position - Vector2(dir.y*speed, dir.x*speed)
				else:
					map[y][map[y].find(11)] = map[pos.x][pos.y]
					map[pos.x][pos.y] = 11
					move = Vector2.ZERO
				break
func step(key, dir):
	if Input.is_key_pressed(key) and move == Vector2.ZERO or move == dir:
		move(dir)

# flag when the puzzle is finished
func check_ready():
	for n in range(12):
		var ans_row = ans[n][0]
		var ans_col = ans[n][1]
		if (not img[n].position == Vector2(ans[n][0], ans[n][1])):
			return false
	return true

# reset the puzzle game
func reset():
	var root = get_tree().get_root()
	var pos = get_node(".").position
	root.get_node("Room/YSort/Player/Camera2D").remove_child(get_node("."))
	
	var new_scene = load("res://sliding_poster.tscn")
	var new = new_scene.instance()
	new.position = pos
	new.scale = Vector2(0.3, 0.3)
	new.name = "Puzzle"
	new._start_show()
	root.get_node("Room/YSort/Player/Camera2D").add_child(new)

func _physics_process(_delta):
#	print(check_ready())
	if (check_ready()):
		pop_up.rect_global_position = Vector2(95, 130)
		pop_up.show()
	if showing:
		step(KEY_DOWN, Vector2(-1, 0))
		step(KEY_RIGHT, Vector2(0, -1))
		step(KEY_LEFT, Vector2(0, 1))
		step(KEY_UP, Vector2(1, 0))
		counter += 1
	
	
func _start_show():
	show()
	showing = true
		
func _on_Quit_pressed():
	counter = 0
	hide()
	showing = false
	get_node("../blur").hide()
	get_node("/root/Room/YSort/Player").canMove = true