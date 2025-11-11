extends Node2D

@export var camera_path: NodePath
@export var parallax_scale: float = 0.2

var camera: Camera2D = null
var initial_positions: Array[Vector2] = []

func _ready():
	if camera_path != null and has_node(camera_path):
		camera = get_node(camera_path)
	
	# Store initial positions of all children
	for child in get_children():
		if child is Node2D:
			initial_positions.append(child.position)

func _process(_delta):
	if camera != null:
		var camera_offset = (camera.position.x - 400) * parallax_scale  # Use screen center instead of world center
		
		# Move each background element at a slightly different speed for more depth
		var index = 0
		for child in get_children():
			if child is Node2D and index < initial_positions.size():
				var depth_factor = 1.0 - (index * 0.08)
				child.position.x = initial_positions[index].x - camera_offset * depth_factor
				index += 1