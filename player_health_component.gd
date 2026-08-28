extends Node3D

@export var health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.is_in_group("Asteroids"):
		health -= 1
		print("hit")
		body.queue_free()
		if health == 0:
			get_tree().quit()
		# make small explosion
