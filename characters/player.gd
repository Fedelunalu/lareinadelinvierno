extends CharacterBody2D

# Player physics parameters
@export var walk_speed = 200
@export var run_speed = 350
@export var jump_velocity = -400
@export var gravity = 1000
@export var fall_gravity_multiplier = 1.5  # Higher gravity when falling
@export var jump_gravity_multiplier = 0.8  # Lower gravity when jumping
@export var acceleration = 800
@export var friction = 800

# Coyote time parameters
@export var coyote_time = 0.15
var coyote_timer = 0.0

# Variable jump height
@export var jump_release_gravity_multiplier = 2.0
var is_jumping = false

# Animation variables
var direction = Vector2()
var is_moving = false
var is_running = false
var animation_frame = 0.0
var previous_direction = 1  # Track the last direction faced

# Visual effects
var original_scale = Vector2(2.0, 2.0)
var squash_factor = 0.08
var stretch_factor = 0.08

# Animation blending
var idle_frame = 0.0
var walk_frame = 0.0
var run_frame = 0.0
var jump_frame = 0.0

# Animation weights for blending
var idle_weight = 1.0
var walk_weight = 0.0
var run_weight = 0.0
var jump_weight = 0.0

# Advanced animation effects
var breathe_amount = 0.0
var breathe_speed = 1.0
var breathe_intensity = 0.02

# Animation states
enum { IDLE, WALKING, RUNNING, JUMPING, FALLING }
var current_state = IDLE
var previous_state = IDLE

# Interaction system
var interact_label = null

func _ready():
	# Set up collision shape
	var collision_shape = get_node_or_null("CollisionShape2D")
	if collision_shape != null:
		if collision_shape.shape == null:
			var shape = CapsuleShape2D.new()
			shape.height = 60  # 2.0 times the original height (30 * 2.0)
			shape.radius = 30  # 2.0 times the original radius (15 * 2.0)
			collision_shape.shape = shape
		# Make sure the collision shape is properly positioned
		collision_shape.position = Vector2(0, 0)
	
	# Initialize sprite modulate
	$Sprite.modulate = Color(1, 1, 1, 1)
	
	# Get reference to interact label
	interact_label = get_tree().get_root().get_node_or_null("Main/InteractLabel")

func _physics_process(delta):
	# Update coyote timer
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# Apply variable gravity
	var current_gravity = gravity
	if velocity.y < 0 and is_jumping and not Input.is_action_pressed("ui_up"):
		# Player released jump button while going up - apply higher gravity
		current_gravity *= jump_release_gravity_multiplier
	elif velocity.y < 0:
		# Player is jumping up - apply lower gravity for better feel
		current_gravity *= jump_gravity_multiplier
	elif velocity.y > 0:
		# Player is falling - apply higher gravity for better responsiveness
		current_gravity *= fall_gravity_multiplier

	velocity.y += current_gravity * delta

	# Get input direction
	direction = Vector2()

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Check if running
	is_running = Input.is_action_pressed("ui_select")  # Use a special key for running

	# Normalize direction for consistent speed
	direction = direction.normalized()

	# Handle horizontal movement with acceleration
	var target_speed = 0
	if direction.x != 0:
		if is_running:
			target_speed = direction.x * run_speed
		else:
			target_speed = direction.x * walk_speed
		velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Handle jumping with coyote time
	if Input.is_action_just_pressed("ui_up") and (is_on_floor() or coyote_timer > 0):
		velocity.y = jump_velocity
		coyote_timer = 0  # Reset coyote timer after jumping
		is_jumping = true
		# Stretch effect when jumping
		$Sprite.scale = Vector2(original_scale.x - stretch_factor, original_scale.y + stretch_factor)
	elif Input.is_action_just_released("ui_up") and velocity.y < 0:
		is_jumping = false

	# Check if player is moving
	is_moving = direction.length() > 0 and (is_on_floor() or coyote_timer > 0)

	# Determine animation state
	previous_state = current_state
	if not is_on_floor():
		if velocity.y < 0:
			current_state = JUMPING
		else:
			current_state = FALLING
	elif is_running and is_moving:
		current_state = RUNNING
	elif is_moving:
		current_state = WALKING
	else:
		current_state = IDLE

	# Check for scene transition
	if position.x > 4000 and get_tree().current_scene.name == "Main":
		transition_to_escenario2()

	# Update animation weights for blending
	update_animation_weights(delta)

	# Update animation frames
	update_animation_frames(delta)

	# Update sprite direction first (before visual effects that might use it)
	update_sprite_direction()

	# Update visual effects
	update_visual_effects(delta)

	# Move the character - this should be called last in physics process
	move_and_slide()

	# Apply any post-movement adjustments to sprite
	update_sprite_animation()

	# Ensure sprite is fully opaque after all operations
	update_sprite_modulate(delta)

func update_animation_weights(_delta):
	# Reset all weights
	idle_weight = 0.0
	walk_weight = 0.0
	run_weight = 0.0
	jump_weight = 0.0
	
	# Set weight for current state
	match current_state:
		IDLE:
			idle_weight = 1.0
		WALKING:
			walk_weight = 1.0
		RUNNING:
			run_weight = 1.0
		JUMPING, FALLING:
			jump_weight = 1.0

func update_animation_frames(delta):
	# Update all animation frames (even inactive ones for smooth transitions)
	idle_frame += 3.5 * delta
	walk_frame += 7.0 * delta * (abs(velocity.x) / walk_speed)
	run_frame += 14.0 * delta * (abs(velocity.x) / run_speed)
	jump_frame += 10.0 * delta

func update_sprite_animation():
	var sprite = $Sprite

	# Determine which frame to show based on weights with smooth interpolation
	# Use floating point frames for smoother animation, clamped to available frames

	if idle_weight > 0:
		sprite.frame = fmod(idle_frame, 10.0)
	elif walk_weight > 0:
		sprite.frame = fmod(walk_frame, 10.0)
	elif run_weight > 0:
		sprite.frame = fmod(run_frame, 10.0)
	elif jump_weight > 0:
		if current_state == JUMPING:
			sprite.frame = 10 + fmod(jump_frame, 6.0)
		else:  # FALLING
			sprite.frame = 16 + fmod(jump_frame, 8.0)  # Dedicated falling frames 16-23

func update_sprite_direction():
	var sprite = $Sprite
	
	# Flip sprite based on movement direction
	if direction.x > 0:
		sprite.flip_h = false
		previous_direction = 1
	elif direction.x < 0:
		sprite.flip_h = true
		previous_direction = -1
	# When not moving, maintain the last direction faced

func update_visual_effects(delta):
	var sprite = $Sprite
	
	# Reset scale over time
	if sprite.scale != original_scale:
		sprite.scale = sprite.scale.lerp(original_scale, 10 * delta)
	
	# Squash effect when landing
	if is_on_floor() and abs(velocity.x) > 10:
		sprite.scale = Vector2(original_scale.x + squash_factor, original_scale.y - squash_factor)
	
	# Add a subtle bounce effect when walking
	if (current_state == WALKING or current_state == RUNNING) and is_on_floor():
		var bounce = sin(walk_frame * 2.0) * 0.05
		sprite.position.y = bounce
	
	# Add breathing effect when idle
	if current_state == IDLE:
		breathe_amount += breathe_speed * delta
		var breathe = sin(breathe_amount) * breathe_intensity
		sprite.scale = Vector2(original_scale.x + breathe, original_scale.y + breathe)
	
	# Add slight lean effect when changing direction quickly
	if direction.x != 0 and sign(direction.x) != previous_direction:
		sprite.rotation_degrees = -direction.x * 2

func update_sprite_modulate(_delta):
	var sprite = $Sprite

	# Force character to be fully opaque at all times
	# Set modulate directly without interpolation to ensure no transparency
	# Also ensure the sprite's self_modulate is set to opaque
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	sprite.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _unhandled_input(event):
	# Direct key checking instead of using InputMap
	if (event is InputEventKey and event.pressed and (event.keycode == KEY_E or event.keycode == KEY_SPACE)):
		interact()

func _process(_delta):
	# Also check for key presses in _process as a backup
	if Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_SPACE):
		if Input.is_key_pressed(KEY_E):
			Input.action_release("ui_accept") # Prevent continuous triggering
		interact()

func interact():
	print("Interactuando con el entorno...")
	# Check for NPCs in interaction range
	var npcs = get_tree().get_nodes_in_group("npcs")
	print("Found ", npcs.size(), " NPCs in the scene")
	if npcs.size() == 0:
		print("No NPCs found in 'npcs' group!")
	
	var near_npc = false
	for npc in npcs:
		print("Checking NPC: ", npc.name)
		if npc is Area2D:
			var distance = global_position.distance_to(npc.global_position)
			print("NPC ", npc.name, " is at distance ", distance, " and visible: ", npc.visible)
			# Increase interaction range to make it easier to interact
			if distance < 200:
				near_npc = true
				print("Talking to NPC: ", npc.name)
				# Ensure the NPC has a talk method before calling it
				if npc.has_method("talk"):
					# Hide interaction label when talking
					if interact_label != null:
						interact_label.hide()
					npc.talk()
					return
				else:
					print("NPC ", npc.name, " does not have a talk method")
		else:
			print("Node ", npc.name, " is not an Area2D")
	
	# Show/hide interaction label based on proximity to NPCs
	if interact_label != null:
		if near_npc:
			interact_label.show()
		else:
			interact_label.hide()

func transition_to_escenario2():
	# Load the next scene with error checking
	var escenario2_scene = load("res://scenes/escenario2.tscn")
	if escenario2_scene == null:
		push_error("Failed to load escenario2.tscn")
		return
	
	# Optional: Add a fade effect before changing scenes
	# This would require a UIManager or similar system
	
	# Change to the new scene
	get_tree().change_scene_to_packed(escenario2_scene)

# Aquí irá la lógica de interacción con NPCs y objetos