extends Area3D

# Attach to an Area3D positioned wherever you want the "death plane" to be
# (e.g. below the camera, so anything that falls that far ends the game).
# Make sure this node's collision_mask includes the layer the falling
# objects are on (asteroids in this project use collision_layer = 2).

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(_body: Node3D) -> void:
	print("collision")
