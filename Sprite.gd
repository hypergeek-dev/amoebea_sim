extends Sprite2D

var speed = 300
var direction = Vector2.ZERO
var target_direction = Vector2.ZERO
var change_interval = 5.0
var time_since_last_change = 0.0
var noise
var noise_time = 0.0

func _ready():
	print("Script is running on node: ", self.name)
	randomize()
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	target_direction = direction
	change_interval = rand_range(3, 5)
	
	
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
	position += direction * speed * delta
	direction = direction.lerp(target_direction, 0.02)

	time_since_last_change += delta
	noise_time += delta

	if time_since_last_change >= change_interval:
		var noise_value_x = noise.get_noise_2d(position.x * 0.1, noise_time)
		var noise_value_y = noise.get_noise_2d(position.y * 0.1, noise_time)
		target_direction = Vector2(noise_value_x, noise_value_y).normalized()
		
		time_since_last_change = 0.0
		change_interval = rand_range(3, 5)

	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = 0
		direction.x *= -1
		target_direction.x *= -1
	elif position.x > screen_size.x:
		position.x = screen_size.x
		direction.x *= -1
		target_direction.x *= -1

	if position.y < 0:
		position.y = 0
		direction.y *= -1
		target_direction.y *= -1
	elif position.y > screen_size.y:
		position.y = screen_size.y
		direction.y *= -1
		target_direction.y *= -1

func _on_Amoeba_Area_area_entered(area):
	print("Area entered detected.")
	if area.is_in_group("bacteria"):
		print("Bacteria detected!")
		area.queue_free()  
		scale += Vector2(0.1, 0.1)

func rand_range(min, max):
	return min + (max - min) * randf()
