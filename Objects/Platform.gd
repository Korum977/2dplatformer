extends StaticBody2D

@export var bounce_force : float = -500.0
@export var bottom_bounce_multiplier : float = 0.3

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var is_enabled : bool = false
var last_collision_direction : Vector2 = Vector2.ZERO
var player_passing_through : bool = false

func _ready():
	# Start with collision enabled but one-way
	enable()

func enable():
	is_enabled = true
	collision_shape.disabled = false

func disable():
	is_enabled = false
	collision_shape.disabled = true

func handle_collision(body: Node2D, normal: Vector2) -> float:
	if body is CharacterBody2D:
		var player_velocity = body.velocity
		last_collision_direction = normal
		
		# Player is moving up and hitting from below
		if normal.y > 0 and player_velocity.y < 0:
			# One-way collision will automatically handle this
			return 0.0
		
		# Player is moving down and hitting from above
		elif normal.y < 0 and player_velocity.y > 0:
			if not is_enabled:
				enable()
			return bounce_force
			
	return 0.0 