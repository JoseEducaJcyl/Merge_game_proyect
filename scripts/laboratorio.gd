extends Control
const COLUMNAS = 4
const FILAS = 4
const TAMANO_CELDA = 120 # El tamaño de cada hueco
const MARGEN = 100 # Para que no empiece pegado a la esquina

var cartas_en_tablero = {} 
@export var carta_scene: PackedScene

func _ready():
	print("He vuelto al laboratorio. Criaturas capturadas: ", Recetas.criaturas_capturadas)
	
	if Recetas.criaturas_capturadas > 0:
		generar_capturas_en_tablero()
	else:
		# Si no hay capturas, tablero vacío
		pass
	
func _on_ir_a_cazar_pressed():
	get_tree().change_scene_to_file("res://minijuego.tscn")	

func llenar_tablero_vacio():
	for col in range(COLUMNAS):
		for fila in range(FILAS):
			var id_celda = Vector2i(col, fila)
			# Si la celda no tiene carta, creamos una
			if not cartas_en_tablero.has(id_celda):
				crear_carta_en_celda(id_celda)

# Función auxiliar para no repetir código
func crear_carta_en_celda(id_celda: Vector2i):
	var nueva_carta = carta_scene.instantiate()
	
	# Elige un ID aleatorio de los básicos
	var ids_basicos = ["rata", "murcielago"]
	nueva_carta.id_criatura = ids_basicos.pick_random()
	
	nueva_carta.position = Vector2(MARGEN + id_celda.x * TAMANO_CELDA, MARGEN + id_celda.y * TAMANO_CELDA)
	nueva_carta.actualizar_visuales()
	
	cartas_en_tablero[id_celda] = nueva_carta
	add_child(nueva_carta)


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/minijuego.tscn")
	
func generar_capturas_en_tablero():
	# Bucle que se repite tantas veces como bichos hayamos atrapado
	for i in range(Recetas.criaturas_capturadas):
		
		# Buscamos un hueco libre en la cuadrícula
		var hueco_encontrado = false
		for col in range(COLUMNAS):
			for fila in range(FILAS):
				var id_celda = Vector2i(col, fila)
				
				# Si la celda está vacía, metemos una carta
				if not cartas_en_tablero.has(id_celda):
					crear_carta_en_celda(id_celda)
					hueco_encontrado = true
					break # Rompemos el bucle de filas
			if hueco_encontrado:
				break # Rompemos el bucle de columnas
				
	# IMPORTANTE: Reseteamos el contador para que no se dupliquen al volver a entrar
	Recetas.criaturas_capturadas = 0	
