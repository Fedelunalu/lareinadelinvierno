extends StaticBody2D

@export var texture: Texture2D

func _ready():
	# Set up the collision shape
	var shape = RectangleShape2D.new()
	shape.size = Vector2(256, 32)
	
	var collision_shape = $CollisionShape2D
	collision_shape.shape = shape
	
	# Set up the sprite
	if texture:
		$Sprite2D.texture = texture
		$Sprite2D.hframes = 8
		$Sprite2D.vframes = 4
		$Sprite2D.frame = 0