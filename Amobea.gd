extends Amobea

var speed = 100  # Speed of the element
var direction = Vector2.ZERO

func _ready():
	randomize()
	# Set initial random direction
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _process(delta):
	# Move the element
	position += direction * speed * delta

	# Change direction randomly at intervals
	if randf() < 0.01:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

	# Keep the element within the screen bounds
	var screen_size = get_viewport_rect().size
	if position.x < 0:
		position.x = 0
		direction.x *= -1
	elif position.x > screen_size.x:
		position.x = screen_size.x
		direction.x *= -1

	if position.y < 0:
		position.y = 0
		direction.y *= -1
	elif position.y > screen_size.y:
		position.y = screen_size.y
		direction.y *= -1

func randf_range(min, max):
	return min + (max - min) * randf()
