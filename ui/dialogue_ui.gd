extends CanvasLayer

@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var options_container = $Panel/OptionsContainer

var current_dialogue = []
var current_index = 0
var current_speaker = ""

signal dialogue_finished()

func _ready():
	hide()
	if panel != null and not panel.gui_input.is_connected(_on_panel_gui_input):
		panel.gui_input.connect(_on_panel_gui_input)

func show_dialogue(text):
	if typeof(text) == TYPE_ARRAY:
		current_dialogue = text
		current_index = 0
		display_current_line()
	else:
		if label != null:
			label.text = text
		show()
	
	# Hide options container when showing regular dialogue
	if options_container != null:
		options_container.hide()

func display_current_line():
	if current_index < current_dialogue.size():
		if label != null:
			label.text = current_dialogue[current_index]
			if current_speaker != "":
				label.text = current_speaker + ": " + label.text
		show()

func next_line():
	current_index += 1
	if current_index >= current_dialogue.size():
		hide_dialogue()
		dialogue_finished.emit()
	else:
		display_current_line()

func hide_dialogue():
	hide()
	current_dialogue = []
	current_index = 0
	current_speaker = ""
	
	# Clear options
	if options_container != null:
		for child in options_container.get_children():
			child.queue_free()
		
		options_container.hide()

func set_speaker(speaker_name):
	current_speaker = speaker_name

func _on_panel_gui_input(event):
	if event is InputEventKey and event.pressed and current_dialogue.size() > 0:
		next_line()
	elif event is InputEventMouseButton and event.pressed and current_dialogue.size() > 0:
		next_line()
