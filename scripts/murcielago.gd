extends CharacterBody2D

var velocidad = randf_range(150.0, 250.0)
var direccion = Vector2.ZERO

func _ready():
	add_to_group("criatura") # <--- ESTA LÍNEA
	direccion = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if direccion == Vector2.ZERO:
		direccion = Vector2(1, 1).normalized()
		
	# Hacemos que ignore las colisiones al nacer
	set_collision_mask_value(1, false) 
	
	# Esperamos 0.5 segundos y volvemos a activar las colisiones
	await get_tree().create_timer(0.5).timeout
	set_collision_mask_value(1, true)

func _physics_process(delta):
	velocity = direccion * velocidad
	move_and_slide()
	
	# Si choca contra el fondo o las paredes
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		direccion = direccion.bounce(collision.get_normal())
