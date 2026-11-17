extends TextureRect

var id_criatura: String = "rata"
var ya_fusionada = false

func _get_drag_data(_at_position):
	var preview = TextureRect.new()
	preview.texture = texture
	preview.size = size
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.position = -size / 2
	set_drag_preview(preview)
	
	return {
		"origen": self,
		"id": id_criatura
	}

func _can_drop_data(_at_position, data):
	if data is Dictionary and data.has("id"):
		if data["origen"] == self: 
			return false
		if ya_fusionada or data["origen"].ya_fusionada:
			return false
			
		var resultado = Recetas.obtener_resultado(self.id_criatura, data["id"])
		return resultado != "" 
	return false

func _drop_data(_at_position, data):
	if ya_fusionada:
		return
		
	var carta_origen = data["origen"]
	var escena_principal = get_parent()
	
	if not escena_principal or not "BASE_X" in escena_principal:
		return

	var col_destino = round((position.x - escena_principal.BASE_X) / escena_principal.ANCHO_CELDA)
	var fila_destino = round((position.y - escena_principal.BASE_Y) / escena_principal.ALTO_CELDA)
	var celda_destino = Vector2i(col_destino, fila_destino)
	
	var col_origen = round((carta_origen.position.x - escena_principal.BASE_X) / escena_principal.ANCHO_CELDA)
	var fila_origen = round((carta_origen.position.y - escena_principal.BASE_Y) / escena_principal.ALTO_CELDA)
	var celda_origen = Vector2i(col_origen, fila_origen)

	if celda_destino == celda_origen:
		return
		
	ya_fusionada = true
	carta_origen.ya_fusionada = true
	
	var nuevo_id = Recetas.obtener_resultado(self.id_criatura, data["id"])
	
	escena_principal.cartas_en_tablero.erase(celda_origen)
	carta_origen.queue_free()
	
	self.id_criatura = nuevo_id
	self.position = escena_principal.calcular_posicion_celda(celda_destino)
	self.actualizar_visuales()
	
	escena_principal.cartas_en_tablero[celda_destino] = self
	
	await get_tree().process_frame
	if is_instance_valid(self):
		ya_fusionada = false

func actualizar_visuales():
	var texturas = {
		"rata": preload("res://assets/rat.png"),
		"murcielago": preload("res://assets/bat.png"),
		"rata_voladora": preload("res://assets/ratbat.png")
	}
	
	if texturas.has(id_criatura):
		texture = texturas[id_criatura]
		modulate = Color.WHITE
		
	# Reducimos ligeramente el tamaño (130x90 en vez de 152x107) para que no toquen los bordes negros
	custom_minimum_size = Vector2(130, 90)
	size = Vector2(130, 90)
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
