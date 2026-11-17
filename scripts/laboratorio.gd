extends Control

const COLUMNAS = 4
const FILAS = 4

# Medidas exactas de la cuadrícula verde de tu dibujo en pantalla (1150x643)
const ANCHO_CELDA = 152.0
const ALTO_CELDA = 107.0
const BASE_X = 127.0
const BASE_Y = 81.0

var cartas_en_tablero = {} 
@export var carta_scene: PackedScene

func _ready():
	cartas_en_tablero.clear()
	var capturas = Recetas.criaturas_capturadas
	
	if capturas > 0:
		generar_capturas_en_tablero() 
		$Label.text = "¡Has traído " + str(capturas) + " criaturas!"
		$Label.visible = true
	else:
		if Recetas.tablero_guardado.size() > 0:
			for celda in Recetas.tablero_guardado:
				var id_criatura = Recetas.tablero_guardado[celda]
				if id_criatura != "":
					crear_carta_en_celda(celda, id_criatura)
			
	if cartas_en_tablero.size() > 0:
		$Label.visible = false
	else:
		$Label.text = "¡El laboratorio está vacío! Ve a cazar"
		$Label.visible = true

func calcular_posicion_celda(celda: Vector2i) -> Vector2:
	return Vector2(
		BASE_X + (celda.x * ANCHO_CELDA),
		BASE_Y + (celda.y * ALTO_CELDA)
	)

func crear_carta_en_celda(id_celda: Vector2i, id_especifico: String = ""):
	var nueva_carta = carta_scene.instantiate()
	if id_especifico != "":
		nueva_carta.id_criatura = id_especifico
	else:
		var ids_basicos = ["rata", "murcielago"]
		nueva_carta.id_criatura = ids_basicos.pick_random()
	
	nueva_carta.position = calcular_posicion_celda(id_celda)
	nueva_carta.actualizar_visuales()
	cartas_en_tablero[id_celda] = nueva_carta
	add_child(nueva_carta)

func _on_button_pressed():
	guardar_estado_tablero()
	get_tree().change_scene_to_file("res://scenes/minijuego.tscn")

func guardar_estado_tablero():
	Recetas.tablero_guardado.clear()
	for celda in cartas_en_tablero:
		if is_instance_valid(cartas_en_tablero[celda]):
			Recetas.tablero_guardado[celda] = cartas_en_tablero[celda].id_criatura

func generar_capturas_en_tablero():
	for i in range(Recetas.criaturas_capturadas):
		var hueco_encontrado = false
		for fila in range(FILAS):
			for col in range(COLUMNAS):
				var id_celda = Vector2i(col, fila)
				if not cartas_en_tablero.has(id_celda) or not is_instance_valid(cartas_en_tablero[id_celda]):
					crear_carta_en_celda(id_celda)
					hueco_encontrado = true
					break
			if hueco_encontrado:
				break
				
	Recetas.criaturas_capturadas = 0
	guardar_estado_tablero()
