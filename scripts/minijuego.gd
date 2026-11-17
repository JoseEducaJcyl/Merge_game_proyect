extends Node2D

@export var rata_scene: PackedScene
@export var murcielago_scene: PackedScene
var bichos_generados = 0
const MAX_BICHOS = 7

func _ready():
	# Forzamos la conexión del Timer por código (a prueba de fallos)
	$Timer.timeout.connect(_on_timer_timeout)
	
func _on_body_entered(body):
	if body.is_in_group("criatura"):
		Recetas.criaturas_capturadas += 1
		body.queue_free()
		
		# Actualizar UI si el label existe
		var label = get_parent().get_node_or_null("LabelContador")
		if label:
			label.text = "Atrapados: " + str(Recetas.criaturas_capturadas)	
			
func _on_volver_pressed():
	# Paramos el timer por si acaso
	$Timer.stop()
	get_tree().change_scene_to_file("res://scenes/laboratorio.tscn")			

func _on_timer_timeout():
	if bichos_generados < MAX_BICHOS:
		var bicho
		if randi() % 2 == 0:
			bicho = rata_scene.instantiate()
		else:
			bicho = murcielago_scene.instantiate()
		
		# Genera en los bordes (X de -500 a 500, Y de -250 a 250)
		var lado = randi() % 4
		var pos_spawn = Vector2.ZERO
		if lado == 0: pos_spawn = Vector2(randf_range(-500, 500), -250) # Arriba
		elif lado == 1: pos_spawn = Vector2(randf_range(-500, 500), 250) # Abajo
		elif lado == 2: pos_spawn = Vector2(-500, randf_range(-250, 250)) # Izquierda
		else: pos_spawn = Vector2(500, randf_range(-250, 250)) # Derecha
		
		bicho.position = pos_spawn
		add_child(bicho)
		bichos_generados += 1
		print("Bicho generado en: ", pos_spawn) # Para ver en consola que funciona
	else:
		$Timer.stop()
		print("Volviendo al laboratorio con ", Recetas.criaturas_capturadas, " criaturas.")
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/laboratorio.tscn")
