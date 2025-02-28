extends Camera2D

var highest_reached_y : float = 0

func _process(_delta):
	# Only update camera's vertical position if player goes higher than before
	if position.y < highest_reached_y:
		highest_reached_y = position.y
		# Keep horizontal position fixed while following vertical movement
		position.y = highest_reached_y
	else:
		position.y = highest_reached_y 