# PilotStick.gd
extends RigidBody3D

# States
var is_grabbed: bool = false
var grab_hand: XRController3D = null
var grab_offset: Transform3D

func _physics_process(delta):
	if is_grabbed and grab_hand:
		# Match the grab hand transform while maintaining initial offset
		global_transform = grab_hand.global_transform * grab_offset
