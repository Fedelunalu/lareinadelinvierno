extends Area2D

# Nombre del NPC
@export var character_name := "Consejero Real"

# Diálogo del NPC
@export var dialogue = [
	"Oh, majestuosa Reina del Invierno, noto preocupación en tus ojos.",
	"El reino sufre con este eterno invierno, y sé que tú también sufres en silencio.",
	"Tu identidad como reina y como persona ha sido cuestionada por muchos...",
	"Pero yo creo firmemente en tu derecho a ser quien eres, sin importar el frío que nos rodea.",
	"Recuerda siempre que tu autenticidad es tu mayor poder."
]

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
		return []