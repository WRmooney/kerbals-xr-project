extends Node3D

@onready var right_controller = $"../XROrigin3D/XRControllerRight"

func _process(delta):
	var grip_value = right_controller.get_float("grip")
	
	if grip_value > 0.5:
		print("GRIP PRESSED!")
