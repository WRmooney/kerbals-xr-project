# In XRController.gd
extends XRController3D

func _physics_process(delta):
	if is_button_pressed(""):
		check_for_grab()

func check_for_grab():
	var stick = get_overlapping_stick()
	if stick and not stick.is_grabbed:
		stick.is_grabbed = true
		stick.grab_hand = self
		stick.grab_offset = stick.global_transform.affine_inverse() * global_transform
