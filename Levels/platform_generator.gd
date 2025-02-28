extends Node2D

const BasePlatform = preload("res://Objects/BasePlatform.tscn")
const BouncePlatform = preload("res://Objects/Platform.tscn")
const PLATFORM_Y_SPACING = 100  # Vertical space between platforms
const VIEWPORT_BUFFER = 200  # Generate platforms this far above viewport
const BOUNCE_PLATFORM_CHANCE = 0.3  # 30% chance for bounce platforms

var highest_platform_y : int = 0
var rng = RandomNumberGenerator.new()
var ground_scene = preload("res://Objects/ground.tscn")
var score = 0
const SPAWN_THRESHOLD = 5000

signal score_changed(new_score)

func _ready():
	rng.randomize()
	# Start generating initial platforms
	generate_platforms()
	# Подписываемся на сигнал изменения счёта
	# Предполагается, что у вас есть сигнал score_changed

func _process(_delta):
	# Check if we need to generate more platforms
	var camera_y = get_viewport().get_camera_2d().position.y
	if highest_platform_y > camera_y - VIEWPORT_BUFFER:
		generate_platforms()

func generate_platforms():
	var viewport_size = get_viewport_rect().size
	var platforms_to_generate = 5
	
	for i in range(platforms_to_generate):
		# Randomly choose between base and bounce platform
		var platform = BouncePlatform.instantiate() if rng.randf() < BOUNCE_PLATFORM_CHANCE else BasePlatform.instantiate()
		add_child(platform)
		platform.add_to_group("platforms")
		
		# Calculate platform position
		var platform_y = highest_platform_y - PLATFORM_Y_SPACING
		var platform_x = rng.randi_range(
			platform.get_node("CollisionShape2D").shape.size.x,  # Left margin
			viewport_size.x - platform.get_node("CollisionShape2D").shape.size.x   # Right margin
		)
		
		platform.position = Vector2(platform_x, platform_y)
		highest_platform_y = platform_y 

func _on_score_changed(new_score):
	score = new_score
	if score % SPAWN_THRESHOLD == 0:
		spawn_platform()

func spawn_platform():
	var platform = ground_scene.instantiate()
	# Установите позицию для новой платформы
	# Например, справа от экрана
	var viewport_size = get_viewport().get_visible_rect().size
	platform.position = Vector2(
		viewport_size.x + 100,  # За пределами экрана справа
		viewport_size.y - 200   # Немного выше нижней границы экрана
	)
	add_child(platform) 
