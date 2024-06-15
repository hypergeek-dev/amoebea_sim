extends Node2D

@export var bacteria_scene: PackedScene
var spawn_timer = 0.0
var next_spawn_time = 0.0

func _ready():
	randomize()
	set_next_spawn_time()

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= next_spawn_time:
		spawn_bacteria()
		set_next_spawn_time()
		spawn_timer = 0.0

func set_next_spawn_time():
	next_spawn_time = rand_range(30.0, 90.0)

func spawn_bacteria():
	if bacteria_scene:
		var bacteria_instance = bacteria_scene.instantiate()
		bacteria_instance.position = get_random_position()
		add_child(bacteria_instance)
		print("Bacteria spawned at position: ", bacteria_instance.position)
	else:
		print("Bacteria scene not set")

func get_random_position():
	var viewport_size = get_viewport_rect().size
	return Vector2(rand_range(0, viewport_size.x), rand_range(0, viewport_size.y))

func rand_range(min, max):
	return min + (max - min) * randf()
