extends XRToolsPickable
class_name PlanarVRJoystick


@export_category("Joystick")

## Node that defines the joystick's movement plane.
## Its local XY plane is the joystick surface.
@export var joystick_plane: Node3D

## Maximum distance the joystick can move from center.
@export var movement_radius: float = 0.04

## How quickly the joystick returns to center after release.
@export var return_speed: float = 12.0

## Deadzone applied to the returned joystick value.
@export_range(0.0, 0.5, 0.01)
var deadzone: float = 0.05


var _center_position: Vector3
var _joystick_value := Vector2.ZERO


func _ready() -> void:
	super._ready()

	if joystick_plane == null:
		push_error("PlanarVRJoystick: joystick_plane is not assigned.")
		return

	# Remember the joystick's starting position in the plane's
	# local coordinate system.
	_center_position = joystick_plane.to_local(global_position)

	# A joystick should not fall due to gravity.
	freeze = true


func _physics_process(delta: float) -> void:
	if joystick_plane == null:
		return

	if is_picked_up():
		print("picked up")
		_update_from_controller()
	else:
		_return_to_center(delta)

	_update_joystick_value()


func _update_from_controller() -> void:
	var controller := get_picked_up_by_controller()

	if controller == null:
		return

	# Convert controller position into the joystick plane's
	# coordinate system.
	var controller_local := joystick_plane.to_local(
		controller.global_position
	)

	# Calculate distance from joystick center.
	var offset := controller_local - _center_position

	# IMPORTANT:
	#
	# The joystick plane is its local XY plane.
	#
	# X = movement along plane X
	# Y = movement along plane Y
	# Z = movement through the plane
	#
	# Throw away the perpendicular component.
	offset.z = 0.0

	# Limit joystick travel to a circle.
	if offset.length() > movement_radius:
		offset = offset.normalized() * movement_radius

	# Convert back to the plane's local coordinates.
	var new_position := _center_position + offset

	# Finally convert that back into world space.
	global_position = joystick_plane.to_global(new_position)


func _return_to_center(delta: float) -> void:
	var current_local := joystick_plane.to_local(global_position)

	current_local.x = move_toward(
		current_local.x,
		_center_position.x,
		return_speed * delta * movement_radius
	)

	current_local.y = move_toward(
		current_local.y,
		_center_position.y,
		return_speed * delta * movement_radius
	)

	current_local.z = _center_position.z

	global_position = joystick_plane.to_global(current_local)


func _update_joystick_value() -> void:
	var local_position := joystick_plane.to_local(global_position)

	var offset := local_position - _center_position

	var value := Vector2(
		offset.x / movement_radius,
		offset.y / movement_radius
	)

	# Clamp to a unit circle.
	value = value.limit_length(1.0)

	# Apply deadzone.
	if value.length() < deadzone:
		value = Vector2.ZERO
	else:
		# Rescale so the value still reaches 1.0 at full travel.
		var magnitude := (value.length() - deadzone) / (1.0 - deadzone)
		value = value.normalized() * magnitude

	_joystick_value = value


func get_joystick_value() -> Vector2:
	return _joystick_value
