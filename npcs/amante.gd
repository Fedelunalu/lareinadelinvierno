extends "res://npcs/npc.gd"

func _ready():
	character_name = "Amante"
	# Ensure the NPC is in the npcs group
	if not is_in_group("npcs"):
		add_to_group("npcs")
	
	# Make sure the NPC sprite is visible
	var sprite = get_node_or_null("Sprite2D")
	if sprite != null:
		sprite.visible = true
		sprite.z_index = 5

func talk():
	# Get the dialogue UI from the scene
	var dialogue_ui = get_tree().get_root().find_child("DialogueUI", true, false)
	if dialogue_ui != null:
		dialogue_ui.set_speaker(character_name)
		dialogue_ui.show_dialogue([
			"¡Hola, viajero!",
			"¿En qué puedo ayudarte?"
		])