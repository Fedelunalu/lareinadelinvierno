extends Node2D

@onready var queen = $Queen
@onready var dialogue_ui = $UI

func _ready():
	pass
	# Inicialización del juego

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()