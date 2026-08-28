extends Node3D

@export var xr_origin: XROrigin3D

@onready var joystick = $Joystick

var cam_resets = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	XRServer.center_on_hmd(XRServer.DONT_RESET_ROTATION, false)
	if get_parent():
		xr_origin = get_parent().xr_origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cam_resets < 30:
		XRServer.center_on_hmd(XRServer.DONT_RESET_ROTATION, false)
		cam_resets += 1
	print(joystick)
	if joystick:
		var joystick_val = joystick.get_input()
		position.y += joystick_val.y * 0.1
		position.z += joystick_val.x * -0.1
		xr_origin.position.y += joystick_val.y * 0.1
		xr_origin.position.z += joystick_val.x * -0.1
		print(position)
