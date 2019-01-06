extends Camera

var SPEED_NORMAL = 4
var SPEED_FAST = 10

func _ready():
	set_process(false)

func _process(delta):
	var speed = SPEED_NORMAL;
	if Input.is_key_pressed(KEY_SHIFT):
		speed = SPEED_FAST
	
	var back = get_camera_transform().basis.z
	var right = get_camera_transform().basis.x
	
	if Input.is_key_pressed(KEY_W):
		global_translate(-back * delta * speed)
	if Input.is_key_pressed(KEY_S):
		global_translate(back * delta * speed)
	if Input.is_key_pressed(KEY_A):
		global_translate(-right * delta * speed)
	if Input.is_key_pressed(KEY_D):
		global_translate(right * delta * speed)

func _input(event):
	if event is InputEventMouseMotion and is_processing():
		mouse_motion(event)
	if event is InputEventMouseButton:
		mouse_button(event)

func mouse_motion(event):
	self.global_rotate(Vector3.UP, -event.relative.x/200)
	self.global_rotate(get_camera_transform().basis.x, -event.relative.y/200)

func mouse_button(event):
	if event.button_index == BUTTON_RIGHT:
		if event.pressed:
			set_process(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			set_process(false)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)