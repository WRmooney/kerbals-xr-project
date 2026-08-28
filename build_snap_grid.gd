extends Node3D
@onready var area_3d: Area3D = $Area3D
@onready var area_3d_2: Area3D = $Area3D2


# Called when the node enters the scene tree for the first time.



func _on_area_3d_body_entered(body):
	body.global_transform = area_3d.global_transform


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	body.global_transform = area_3d_2.global_transform


func _on_area_3d_3_body_entered(body: Node3D) -> void:
	pass # Replace with function body.




func _on_area_3d_4_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
