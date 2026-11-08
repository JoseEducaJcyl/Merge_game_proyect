extends Control
const COLUMNAS = 4
const FILAS = 4
const TAMANO_CELDA = 120 # El tamaño de cada hueco
const MARGEN = 100 # Para que no empiece pegado a la esquina

var cartas_en_tablero = {} 
@export var carta_scene: PackedScene

func _ready():
	# Llenamos el tablero al iniciar el juego
	llenar_tablero_vacio()

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


func _on_button_pressed() -> void:
	# Esto recarga la escena actual desde cero
	get_tree().reload_current_scene()
