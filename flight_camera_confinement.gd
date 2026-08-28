extends XROrigin3D

@onready var player_cam = $XRCamera3D
@onready var spawn_point = $"../VRSpawn"
@export var cube_radius : float = 0.45 # CHANGE TO BE MORE ACCURATE LATER

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Ensure player camera does not leave the bounds of the ship
	if player_cam.global_position.x - spawn_point.global_position.x > cube_radius:
		player_cam.global_position.x = spawn_point.global_position.x + cube_radius
	elif player_cam.global_position.x - spawn_point.global_position.x < (cube_radius * -1):
		player_cam.global_position.x = spawn_point.global_position.x - cube_radius
	if player_cam.global_position.y - spawn_point.global_position.y > cube_radius:
		player_cam.global_position.y = spawn_point.global_position.y + cube_radius
	elif player_cam.global_position.y - spawn_point.global_position.y < (cube_radius * -1):
		player_cam.global_position.y = spawn_point.global_position.y - cube_radius
	if player_cam.global_position.z - spawn_point.global_position.z > cube_radius:
		player_cam.global_position.z = spawn_point.global_position.z + cube_radius
	elif player_cam.global_position.z - spawn_point.global_position.z < (cube_radius * -1):
		player_cam.global_position.z = spawn_point.global_position.z - cube_radius
