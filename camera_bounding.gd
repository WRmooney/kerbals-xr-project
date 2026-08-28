extends XROrigin3D


# ============================================================
# HEADSET BOUNDING BOX
# ============================================================

@export_category("Headset Boundary")

# Maximum headset distance from the XR origin on X.
@export var boundary_x: float = 0.45

# Maximum headset distance from the XR origin on Z.
@export var boundary_z: float = 0.35

# Minimum and maximum headset height.
@export var boundary_y_min: float = -0.30
@export var boundary_y_max: float = 0.30


# ============================================================
# SAFETY MARGIN
# ============================================================

@export_category("Safety Margin")

# Keeps the headset slightly inside the boundary.
@export var margin: float = 0.05


# ============================================================
# CORRECTION
# ============================================================

@export_category("Correction")

# 1.0 = immediately keep headset inside boundary.
# Lower values make the correction softer.
@export_range(0.0, 1.0)
var correction_strength: float = 1.0


# ============================================================
# NODES
# ============================================================

@onready var camera: XRCamera3D = $XRCamera3D


# ============================================================
# PROCESS
# ============================================================

func _process(_delta: float) -> void:

	if camera == null:
		return


	# The camera's position is relative to XROrigin3D.
	var head_position: Vector3 = camera.position

	var correction := Vector3.ZERO


	# ========================================================
	# X AXIS
	# ========================================================

	var max_x := boundary_x - margin


	if head_position.x > max_x:

		correction.x = max_x - head_position.x

	elif head_position.x < -max_x:

		correction.x = -max_x - head_position.x


	# ========================================================
	# Y AXIS
	# ========================================================

	var min_y := boundary_y_min + margin
	var max_y := boundary_y_max - margin


	if head_position.y > max_y:

		correction.y = max_y - head_position.y

	elif head_position.y < min_y:

		correction.y = min_y - head_position.y


	# ========================================================
	# Z AXIS
	# ========================================================

	var max_z := boundary_z - margin


	if head_position.z > max_z:

		correction.z = max_z - head_position.z

	elif head_position.z < -max_z:

		correction.z = -max_z - head_position.z


	# ========================================================
	# APPLY CORRECTION
	# ========================================================

	if correction != Vector3.ZERO:

		position += correction * correction_strength
