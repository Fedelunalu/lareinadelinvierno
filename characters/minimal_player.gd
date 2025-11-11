extends CharacterBody2D

func _physics_process(_delta):
	velocity.x = 0
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = 100
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x = -100
	move_and_slide()