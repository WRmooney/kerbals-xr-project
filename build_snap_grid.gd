extends Node3D
@onready var area_3d: Area3D = $Area3D
@onready var area_3d_2: Area3D = $Area3D2
@onready var area_3d_3: Area3D = $Area3D3
@onready var area_3d_4: Area3D = $Area3D4
@onready var body: RigidBody3D = $"."
@onready var thruster: Node3D = $Root
@onready var tip: Node3D = $"."



# Called when the node enters the scene tree for the first time.



func _on_area_3d_body_entered():
	body.global_transform = area_3d.global_transform


func _on_area_3d_2_body_entered():
	tip.global_transform = area_3d_2.global_transform


func _on_area_3d_3_body_entered():
	thruster.global_transform = area_3d_3.global_transform


func _on_area_3d_4_body_entered():
	fin.global_transform = area_3d_4.global_transform
