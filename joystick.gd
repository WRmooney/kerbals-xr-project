extends Node3D


# ============================================================
# JOYSTICK SETTINGS
# ============================================================

@export_category("Joystick Limits")

# Maximum travel distance on the joystick's local X axis.
@export var max_x: float = 0.10

# Maximum travel distance on the joystick's local Y axis.
@export var max_y: float = 0.10


@export_category("Joystick Feel")

# How quickly the joystick returns to center after release.
@export var spring_speed: float = 10.0

# How quickly the joystick follows the controller.
@export var movement_smoothing: float = 20.0

# Small area around the center that produces no input.
@export_range(0.0, 0.5)
var deadzone: float = 0.08


# ============================================================
# VR CONTROLLERS
# ============================================================

# These should be assigned from your Main scene.
@export_category("VR Controllers")

@export var controller_r: XRController3D
@export var controller_l: XRController3D


# ============================================================
# NODES
# ============================================================

@onready var stick: Node3D = $Pivot/Stick


# ============================================================
# STATE
# ============================================================

# Whether the joystick is currently being held.
var grabbed: bool = false

# The controller currently holding the joystick.
var active_controller: XRController3D = null

# Position difference between the controller and joystick
# when the player initially grabs it.
var grab_offset: Vector3 = Vector3.ZERO


# ============================================================
# PROCESS
# ============================================================

func _process(delta: float) -> void:

	# Make sure both controllers have been assigned.
	if controller_r == null or controller_l == null:
		return
	# ========================================================
	# FIND A CONTROLLER TRYING TO GRAB
	# ========================================================

	if not grabbed:

		var right_grabbing := \
			controller_r.is_button_pressed("grip_click")

		var left_grabbing := \
			controller_l.is_button_pressed("grip_click")

		# Right controller gets priority if both are pressed
		# on exactly the same frame.
		if right_grabbing:

			start_grab(controller_r)

		elif left_grabbing:

			start_grab(controller_l)


	# ========================================================
	# CONTINUE WITH ACTIVE CONTROLLER
	# ========================================================

	if grabbed:

		if active_controller == null:
			end_grab()

		elif active_controller.is_button_pressed("grip_click"):

			update_joystick(delta)

		else:

			end_grab()


	# ========================================================
	# SPRING BACK TO CENTER
	# ========================================================

	if not grabbed:

		return_to_center(delta)


# ============================================================
# START GRAB
# ============================================================

func start_grab(controller: XRController3D) -> void:

	grabbed = true

	active_controller = controller


	# Convert the controller's world position into
	# the joystick's local coordinate system.
	var controller_local: Vector3 = \
		global_transform.affine_inverse() \
		* controller.global_position


	# Remember the difference between the controller and
	# the current position of the stick.
	#
	# This prevents the joystick from jumping when grabbed.
	grab_offset = controller_local - stick.position


# ============================================================
# END GRAB
# ============================================================

func end_grab() -> void:

	grabbed = false

	active_controller = null

	grab_offset = Vector3.ZERO


# ============================================================
# UPDATE JOYSTICK
# ============================================================

func update_joystick(delta: float) -> void:

	if active_controller == null:
		return


	# Get controller position relative to the joystick.
	var controller_local: Vector3 = \
		global_transform.affine_inverse() \
		* active_controller.global_position
	


	# Apply the grab offset.
	var target: Vector3 = \
		controller_local - grab_offset
	target = target.rotated(Vector3(0,-2,1).normalized(),PI/2.0)


	# ========================================================
	# LOCK Z
	# ========================================================

	# The joystick can ONLY move on its local X/Y plane.
	target.z= 0.0


	# ========================================================
	# LIMIT X
	# ========================================================

	target.x = clamp(
		target.x,
		-max_x,
		max_x
	)


	# ========================================================
	# LIMIT Y
	# ========================================================

	target.y = clamp(
		target.y,
		-max_y,
		max_y
	)


	# ========================================================
	# SMOOTH MOVEMENT
	# ========================================================

	stick.position = stick.position.lerp(
		target,
		movement_smoothing * delta
	)


# ============================================================
# RETURN TO CENTER
# ============================================================

func return_to_center(delta: float) -> void:

	stick.position = stick.position.lerp(
		Vector3.ZERO,
		spring_speed * delta
	)


# ============================================================
# GET JOYSTICK INPUT
# ============================================================

func get_input() -> Vector2:

	# Convert physical joystick position to -1 → +1.
	var input := Vector2(
		stick.position.x / max_x,
		stick.position.y / max_y
	)


	# Keep the values within the expected range.
	input.x = clamp(input.x, -1.0, 1.0)
	input.y = clamp(input.y, -1.0, 1.0)


	# ========================================================
	# DEADZONE
	# ========================================================

	var magnitude := input.length()


	if magnitude < deadzone:
		return Vector2.ZERO


	# ========================================================
	# REMAP AFTER DEADZONE
	# ========================================================

	var remapped_magnitude := \
		(magnitude - deadzone) / (1.0 - deadzone)

	remapped_magnitude = clamp(
		remapped_magnitude,
		0.0,
		1.0
	)


	input = input.normalized() * remapped_magnitude


	return input
