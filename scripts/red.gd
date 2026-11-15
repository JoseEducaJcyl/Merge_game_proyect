extends Area2D

var puede_moverse = false

func _ready():
	# Nos aseguramos de que la red detecta a los cuerpos
	monitoring = true
	global_position = Vector2(0, 0)
	body_entered.connect(_on_body_entered)
	
	await get_tree().create_timer(0.1).timeout
	puede_moverse = true

func _process(_delta):
	if puede_moverse:
		global_position = get_global_mouse_position()

func _on_body_entered(body):
	if body.is_in_group("criatura"):
		Recetas.criaturas_capturadas += 1
		print("¡Atrapado! Llevas: ", Recetas.criaturas_capturadas)
		body.queue_free()
