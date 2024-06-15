extends Sprite2D

var speed = 300
var direction = Vector2.ZERO
var target_direction = Vector2.ZERO
var change_interval = 1.0  
var time_since_last_change = 0.0

func _ready():
	randomize()
	
	direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	target_direction = direction
	change_interval = rand_range(1, 20)

func _process(delta):
	
	position += direction * speed * delta

	direction = direction.lerp(target_direction, 0.1)


	time_since_last_change += delta
	if time_since_last_change >= change_interval:
		target_direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		time_since_last_change = 0.0
		change_interval = rand_range(1, 10)  

	
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

func rand_range(min, max):
	return min + (max - min) * randf()
