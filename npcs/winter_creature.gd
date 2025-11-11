extends Area2D

# Nombre del NPC
@export var character_name := "Criatura del Invierno"

# Diálogo del NPC
@export var dialogue := "¡Hola, Reina del Invierno! ¿Cómo estás sobrellevando este frío eterno?"

# Referencia al sistema de diálogo
var dialogue_system = null

func _ready():
	input_event.connect(_on_input_event)
	
	# Buscar el sistema de diálogo en la escena principal
	dialogue_system = get_tree().get_root().get_node("Main/DialogueUI")

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("interact"):
		talk()

func talk():
	# Mostrar el diálogo cuando el jugador interactúa con este NPC
	if dialogue_system != null:
		dialogue_system.show_dialogue(dialogue)
		return dialogue
	else:
		print("Sistema de diálogo no encontrado")
		return ""