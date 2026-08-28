extends Node3D

@export var asteroid_scene: PackedScene
@export var spawn_interval_min: float = 0.3
@export var spawn_interval_max: float = 0.5
@export var spawn_width: float = 20.0
@export var spawn_depth: float = 20.0
@export var spawn_height: float = 15.0
@export var fall_speed_min: float = 10.0
@export var fall_speed_max: float = 25.0
@export var angular_speed_min: float = -1.5
@export var angular_speed_max: float = 1.5
@export var scale_min: float = 3
@export var scale_max: float = 6
@export var despawn_y: float = -10.0

@onready var timer: Timer = $Timer

const ASTEROID_GROUP := "asteroids"

func _ready() -> void:
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	_schedule_next_spawn()

func _process(_delta: float) -> void:
	_despawn_low_asteroids()

func _on_timer_timeout() -> void:
	_spawn_asteroid()
	_schedule_next_spawn()

func _schedule_next_spawn() -> void:
	timer.wait_time = randf_range(spawn_interval_min, spawn_interval_max)
	timer.start()

func _spawn_asteroid() -> void:
	if asteroid_scene == null:
		return

	var asteroid = asteroid_scene.instantiate()

	var x = randf_range(-spawn_width / 2.0, spawn_width / 2.0)
	var z = randf_range(-spawn_depth / 2.0, spawn_depth / 2.0)
	asteroid.position = Vector3(x, spawn_height, z)

	var random_scale = randf_range(scale_min, scale_max)
	asteroid.scale = Vector3.ONE * random_scale

	asteroid.add_to_group(ASTEROID_GROUP)

	add_child(asteroid)

	# Set velocities AFTER add_child so the body is registered with physics.
	asteroid.sleeping = false
	asteroid.linear_velocity = Vector3(0, -randf_range(fall_speed_min, fall_speed_max), 0)
	asteroid.angular_velocity = Vector3(
		randf_range(angular_speed_min, angular_speed_max),
		randf_range(angular_speed_min, angular_speed_max),
		randf_range(angular_speed_min, angular_speed_max)
	)

func _despawn_low_asteroids() -> void:
	for asteroid in get_tree().get_nodes_in_group(ASTEROID_GROUP):
		if asteroid.global_position.y < despawn_y:
			asteroid.queue_free()
			


func _on_game_over_zone_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
