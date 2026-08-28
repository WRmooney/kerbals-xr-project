extends Node3D

@export var xr_origin: XROrigin3D

@onready var joystick = $JoystickAssembly/JoystickPlane/Joystick

var cam_resets = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	XRServer.center_on_hmd(XRServer.DONT_RESET_ROTATION, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if cam_resets < 30:
		XRServer.center_on_hmd(XRServer.DONT_RESET_ROTATION, false)
		cam_resets += 1
	if joystick:
		var joystick_val = joystick.get_joystick_value()
		position.y += joystick_val.y
		position.z += joystick_val.x
