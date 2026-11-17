extends Control

func _on_button_pressed():
	# Al empezar, reseteamos las variables globales
	Recetas.criaturas_capturadas = 0
	Recetas.tablero_guardado.clear()
	# Vamos al laboratorio
	get_tree().change_scene_to_file("res://scenes/laboratorio.tscn")
