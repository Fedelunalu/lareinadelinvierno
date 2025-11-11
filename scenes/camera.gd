extends Camera2D

# Camera follow parameters
@export var follow_speed = 5.0
@export var horizontal_offset = 0
@export var vertical_offset = -100
@export var left_bound = -1600
@export var right_bound = 12000

# Target to follow
var target = null

func _ready():
	# Find the player node to follow
	target = get_tree().get_root().find_child("Player", true, false)
	
	# Set initial camera position
	if target != null:
		position = target.position + Vector2(horizontal_offset, vertical_offset)

func _process(delta):
	if target != null:
		# Calculate target position with offsets
		var target_pos = target.position + Vector2(horizontal_offset, vertical_offset)
		
		# Smoothly move camera towards target
		position = position.lerp(target_pos, follow_speed * delta)
		
		# Apply horizontal boundaries
		position.x = clamp(position.x, left_bound, right_bound)