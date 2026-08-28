extends Node3D



@export var asteroid_scene: PackedScene
var po1 = preload("res://powerup.tscn")
var po2 = preload("res://powerup2.tscn")
var po3 = preload("res://powerup3.tscn")
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
@export var despawn_x: float = -30
@export var asteroid_container: Node3D
@export var player_ship: Node3D
var score: int = 0
var difficulty_scale: float = 1.0

@onready var timer: Timer = $Timer

const ASTEROID_GROUP := "asteroids"

func _ready() -> void:
	randomize()
	timer.timeout.connect(_on_timer_timeout)
	_schedule_next_spawn()

func _process(_delta: float) -> void:
	global_position = player_ship.global_position
	_despawn_low_asteroids()

func _on_timer_timeout() -> void:
	_spawn_asteroid()
	_schedule_next_spawn()

func _schedule_next_spawn() -> void:
	timer.wait_time = randf_range(spawn_interval_min / difficulty_scale, spawn_interval_max / difficulty_scale)
	timer.start()

func _spawn_asteroid() -> void:
	if asteroid_scene == null:
		return

	var chance = randi_range(1,100)
	var asteroid = asteroid_scene.instantiate()
	if chance == 1:
		asteroid = po1.instantiate()
	elif chance == 2:
		asteroid = po2.instantiate()
	elif chance == 3:
		asteroid = po3.instantiate()
		

	var y = randf_range(-spawn_width / 2.0, spawn_width / 2.0)
	var z = randf_range(-spawn_depth / 2.0, spawn_depth / 2.0)
	asteroid.position = Vector3(spawn_height, global_position.y + y, global_position.z + z)

	var random_scale = randf_range(scale_min, scale_max)
	asteroid.scale = Vector3.ONE * random_scale

	asteroid_container.add_child(asteroid)

	# Set velocities AFTER add_child so the body is registered with physics.
	asteroid.sleeping = false
	asteroid.linear_velocity = Vector3(-randf_range(fall_speed_min, fall_speed_max), 0, 0)
	asteroid.angular_velocity = Vector3(
		randf_range(angular_speed_min, angular_speed_max),
		randf_range(angular_speed_min, angular_speed_max),
		randf_range(angular_speed_min, angular_speed_max)
	)

func _despawn_low_asteroids() -> void:
	for asteroid in get_tree().get_nodes_in_group("Asteroids"):
		if asteroid.global_position.x < despawn_x:
			asteroid.queue_free()
			score += 1
			difficulty_scale *= 1.01
			
