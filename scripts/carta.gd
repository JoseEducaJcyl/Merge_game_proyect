extends TextureRect

var id_criatura: String = "rata" # El ID de la criatura

# 1. Empezar a arrastrar
func _get_drag_data(_at_position):
	var preview = TextureRect.new()
	preview.texture = self.texture
	preview.size = self.size
	preview.modulate = self.modulate
	preview.position = -self.size / 2
	set_drag_preview(preview)
	
	return {
		"origen": self,
		"id": id_criatura
	}

# 2. Aceptar el drop
func _can_drop_data(_at_position, data):
	if data is Dictionary and data.has("id"):
		if data["origen"] == self: return false
		
		# Comprobamos en el libro de recetas si se pueden combinar
		var resultado = Recetas.obtener_resultado(self.id_criatura, data["id"])
		return resultado != "" # Devuelve true solo si hay una receta válida
	return false

# 3. Realizar la combinación
func _drop_data(_at_position, data):
	var carta_origen = data["origen"]
	var escena_principal = get_parent()
	
	# Calculamos las celdas
	var col_destino = int((position.x - escena_principal.MARGEN) / escena_principal.TAMANO_CELDA)
	var fila_destino = int((position.y - escena_principal.MARGEN) / escena_principal.TAMANO_CELDA)
	var celda_destino = Vector2i(col_destino, fila_destino)

	var col_origen = int((carta_origen.position.x - escena_principal.MARGEN) / escena_principal.TAMANO_CELDA)
	var fila_origen = int((carta_origen.position.y - escena_principal.MARGEN) / escena_principal.TAMANO_CELDA)
	var celda_origen = Vector2i(col_origen, fila_origen)

	# ¡LA MAGIA! Obtenemos la nueva criatura
	var nuevo_id = Recetas.obtener_resultado(self.id_criatura, data["id"])
	
	# Cambiamos esta carta por la nueva criatura
	self.id_criatura = nuevo_id
	self.actualizar_visuales()
	
	# Efecto de escala al combinar
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 1.3, 0.1)
	tween.tween_property(self, "scale", scale, 0.1)
	
	# Destruimos la carta arrastrada
	escena_principal.cartas_en_tablero.erase(celda_origen)
	carta_origen.queue_free()

# Función para cambiar la imagen y el color
func actualizar_visuales():
	# Aquí asignaremos las imágenes cuando las tengas
	var texturas = {
		"rata": preload("res://assets/rat.png"),
		"murcielago": preload("res://assets/bat.png"),
		"rata_voladora": preload("res://assets/ratbat.png")
	}
	
	if texturas.has(id_criatura):
		texture = texturas[id_criatura]
		modulate = Color.WHITE # Para que no se tiña de colores raros
		# EFECTO DE VIDA: Pequeño rebote
	# Primero nos aseguramos de que la escala base sea 1
	scale = Vector2(1.0, 1.0) 
	
	# Creamos un Tween para la animación
	var tween = create_tween().set_loops() # set_loops() hace que se repita infinitamente
	
	# Hacemos que se estire un poquito hacia arriba y luego vuelva
	tween.tween_property(self, "scale", Vector2(1.05, 0.95), 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2(0.95, 1.05), 0.5).set_trans(Tween.TRANS_SINE)	
