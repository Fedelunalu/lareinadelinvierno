extends CharacterBody2D

# Velocidad de movimiento de la Reina
@export var walk_speed := 150
@export var run_speed := 250

# Referencias a los nodos
@onready var sprite = $QueenSprite

# Variables de control
var direction := Vector2()
var state := "idle"
var speed := walk_speed

# Texturas para diferentes animaciones
var idle_texture: Texture2D
var walk_texture: Texture2D
var run_texture: Texture2D

func _ready():
	# Cargar texturas si existen
	if ResourceLoader.exists("res://sprites/idle/spritesheet.png"):
		idle_texture = preload("res://sprites/idle/spritesheet.png")
		
	if ResourceLoader.exists("res://sprites/walk_right/spritesheet.png"):
		walk_texture = preload("res://sprites/walk_right/spritesheet.png")
		
	if ResourceLoader.exists("res://sprites/run_right/spritesheet.png"):
		run_texture = preload("res://sprites/run_right/spritesheet.png")
	
	# Configurar sprite inicial
	if idle_texture:
		sprite.texture = idle_texture
		sprite.hframes = 8
		sprite.vframes = 4
		sprite.frame = 0

func _process(delta):
	handle_input()
	update_movement(delta)
	update_state()
	update_animation()

func handle_input():
	direction = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		
	# Correr si se mantiene presionado Shift
	speed = run_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed

func update_movement(_delta):
	# Normalizar la dirección para mantener una velocidad consistente
	direction = direction.normalized()

	# Aplicar el movimiento usando velocity
	velocity = direction * speed
	move_and_slide()

func update_state():
	if direction.length() > 0:
		if speed == run_speed:
			state = "running"
		else:
			state = "walking"
	else:
		state = "idle"

func update_animation():
	# Actualizar animaciones según el estado
	match state:
		"idle":
			if idle_texture and sprite.texture != idle_texture:
				sprite.texture = idle_texture
				sprite.frame = 0
		"walking":
			if walk_texture and sprite.texture != walk_texture:
				sprite.texture = walk_texture
				sprite.frame = 0
		"running":
			if run_texture and sprite.texture != run_texture:
				sprite.texture = run_texture
				sprite.frame = 0

func interact():
	print("La Reina del Invierno está interactuando con el entorno...")
	# Aquí irá la lógica de interacción con NPCs y objetos