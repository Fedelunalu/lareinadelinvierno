extends Area2D

# Nombre del NPC
@export var character_name = "NPC"

# Diálogo del NPC
@export var dialogue = "Hola, soy un NPC."

func _ready():
	# Connect the input_event signal to the handler function
	connect("input_event", _on_NPC_input_event)
	
	# Debug visibility
	print("Base NPC ", name, " ready. Visible: ", visible, " at position: ", global_position)
	var sprite = get_node_or_null("Sprite2D")
	if sprite != null:
		print("Base NPC sprite visible: ", sprite.visible, ", texture assigned: ", sprite.texture != null)
	else:
		print("No Sprite2D node found in base NPC")

func talk():
	# Esta función se llamará cuando el jugador interactúe con el NPC
	var dialogue_ui = get_tree().get_root().find_child("DialogueUI", true, false)
	if dialogue_ui != null:
		dialogue_ui.set_speaker(character_name)
		dialogue_ui.show_dialogue(dialogue)
	return dialogue

func _on_NPC_input_event(_viewport, event, _shape_idx):
	if (event is InputEventKey and event.pressed and event.keycode == KEY_E) or \
	   (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		talk()