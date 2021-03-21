extends Control
const limit = 30

func _ready():
	_set_disabled()
	$Timer.wait_time = $ProgressBar.value
	$Timer.start()


func _physics_process(delta):
	$ProgressBar.value = limit - $Timer.time_left

func _set_disabled():
	$Button.disabled = true
	$Button.modulate = Color(0.5,0.5,0.5,1)
	$Button/icon.modulate = Color(0.25,0.25,0.25)
	
func _on_Timer_timeout():
	$Timer.stop()
	$Button.modulate = Color(1, 1, 1,1)
	$Button/icon.modulate = Color(1, 1, 1)
	$Button.disabled = false
	
func _on_Button_pressed():
	if $Timer.time_left == 0.0:
		$"../../../YSort/Player".fire_special("magazine")
		_set_disabled()	
		$Timer.start(0)
func stop():
	$Timer.stop()


func _input(event):
	if event is InputEventKey and (event.scancode==77 or event.scancode==49):
		_on_Button_pressed()
				
