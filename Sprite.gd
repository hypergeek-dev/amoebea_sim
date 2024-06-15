extends Sprite2D

var speed = 150
var direction = Vector2.ZERO
var target_direction = Vector2.ZERO
var change_interval = 2.0
var time_since_last_change = 0.0
var noise
var noise_time = 0.0

func _ready():
	print("Script is running on node: ", self.name)
	randomize()
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	target_direction = direction
	change_interval = rand_range(1, 3)
	
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.1

	var area2d = $Amoeba_Area
	if area2d:
		print("Amoeba_Area node found, connecting signal on node: ", self.name)
		area2d.connect("area_entered", Callable(self, "_on_Amoeba_Area_area_entered"))
	else:
		print("Error: Amoeba_Area node not found on node: ", self.name)

func _process(delta):
	noise_time += delta
	direction.x = noise.get_noise_2d(noise_time, 0)
	direction.y = noise.get_noise_2d(0, noise_time)
	direction = direction.normalized()

	position += direction * speed * delta

	var screen_size = get_viewport_rect().size

	# Change direction if close to edges
	if position.x < 50 or position.x > screen_size.x - 50:
		direction.x *= -1
		target_direction.x = rand_range(-1, 1)
		time_since_last_change = 0.0
	if position.y < 50 or position.y > screen_size.y - 50:
		direction.y *= -1
		target_direction.y = rand_range(-1, 1)
		time_since_last_change = 0.0

	# Ensure amoeba doesn't get stuck in the corners
	if position.x < 0:
		position.x = 0
	elif position.x > screen_size.x:
		position.x = screen_size.x

	if position.y < 0:
		position.y = 0
	elif position.y > screen_size.y:
		position.y = screen_size.y

	time_since_last_change += delta
	if time_since_last_change >= change_interval:
		target_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		time_since_last_change = 0.0
		change_interval = rand_range(1, 3)

func _on_Amoeba_Area_area_entered(area):
	print("Area entered detected with groups: ", area.get_groups())
	if area.is_in_group("bacteria"):
		print("Bacteria detected! Queueing for deletion: ", area.name, " with parent: ", area.get_parent().name)
		area.call_deferred("queue_free")
		print("Bacteria queued for deletion: ", area.name, " with parent: ", area.get_parent().name)
		scale += Vector2(0.1, 0.1)
	else:
		print("The area entered is not a bacteria")

func rand_range(min, max):
	return min + (max - min) * randf()
