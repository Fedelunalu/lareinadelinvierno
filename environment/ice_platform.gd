extends StaticBody2D

@export var width: int = 12800  # Much larger platform (double the previous size)
@export var height: int = 32

func _ready():
	# Set up the collision shape
	var shape = RectangleShape2D.new()
	shape.size = Vector2(float(width), float(height))
	
	var collision_shape = $CollisionShape2D
	collision_shape.shape = shape
	
	# Position the collision shape at the center of the platform
	collision_shape.position = Vector2(0, 0)
	
	# Configure the sprite
	var sprite = $Sprite2D
	sprite.region_enabled = true
	sprite.region_rect = Rect2(0, 0, 256, 256)