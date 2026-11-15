extends CharacterBody2D

var velocidad = randf_range(150.0, 300.0)
var direccion = Vector2.ZERO

func _ready():
	direccion = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _physics_process(delta):
	velocity = direccion * velocidad
	move_and_slide()
	
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		direccion = direccion.bounce(collision.get_normal())
