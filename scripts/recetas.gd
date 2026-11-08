extends Node

# El diccionario de recetas. La clave es la combinación, el valor es el resultado.
var recetas = {
	"rata+murcielago": "rata_voladora",
	"rata+rata": "rata_gigante",
	"murcielago+murcielago": "murcielago_vampiro",
	"rata_voladora+rata": "rata_dragon"
	# Aquí puedes añadir todas las que quieras
}

# Función que busca si dos cosas se pueden combinar
func obtener_resultado(id1: String, id2: String) -> String:
	# Creamos la clave ordenando alfabéticamente para que "rata+murcielago" sea igual a "murcielago+rata"
	var clave1 = id1 + "+" + id2
	var clave2 = id2 + "+" + id1
	
	if recetas.has(clave1):
		return recetas[clave1]
	elif recetas.has(clave2):
		return recetas[clave2]
	
	return "" # Si no hay receta, devuelve vacío
