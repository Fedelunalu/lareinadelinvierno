extends CanvasLayer

@onready var label = $Panel/Label
@onready var panel = $Panel
@onready var options_container = $Panel/OptionsContainer

var current_dialogue = []
var current_index = 0
var current_speaker = ""
var dialogue_options = []

signal dialogue_finished()
signal option_selected(option_index)

func _ready():
	hide()
	if not panel.gui_input.is_connected(_on_panel_gui_input):
		panel.gui_input.connect(_on_panel_gui_input)

func show_dialogue(text):
	if typeof(text) == TYPE_ARRAY:
		current_dialogue = text
		current_index = 0
		display_current_line()
	else:
		label.text = text
		show()
	
	# Hide options container when showing regular dialogue
	options_container.hide()

func show_dialogue_with_options(dialogue_text, options):
	# Show dialogue
	label.text = dialogue_text
	if current_speaker != "":
		label.text = current_speaker + ": " + label.text
	show()
	
	# Show options
	dialogue_options = options
	_show_options()

func display_current_line():
	if current_index < current_dialogue.size():
		label.text = current_dialogue[current_index]
		if current_speaker != "":
			label.text = current_speaker + ": " + label.text
		show()
		
		# Hide options when displaying regular dialogue
		options_container.hide()

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
	dialogue_options = []
	
	# Clear options
	for child in options_container.get_children():
		child.queue_free()
	
	options_container.hide()

func set_speaker(speaker_name):
	current_speaker = speaker_name

func _show_options():
	# Clear previous options
	for child in options_container.get_children():
		child.queue_free()
	
	# Create option buttons
	for i in range(dialogue_options.size()):
		var button = Button.new()
		button.text = dialogue_options[i]
		button.connect("pressed", _on_option_selected.bind(i))
		options_container.add_child(button)
	
	options_container.show()

func _on_option_selected(option_index):
	option_selected.emit(option_index)
	hide_dialogue()

func _on_panel_gui_input(event):
	if event is InputEventKey and event.pressed and current_dialogue.size() > 0:
		next_line()
	elif event is InputEventMouseButton and event.pressed and current_dialogue.size() > 0:
		next_line()