extends Control

@onready var score_label = $ScoreLabel
@onready var player = $"../../Player"

func _process(_delta):
	# Update score display
	var score = int(player.score)
	score_label.text = "Score: %d" % score 
