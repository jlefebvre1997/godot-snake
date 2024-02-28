extends Node

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameOverScreen.hide()
	update_score(score)
	reset_apple_position()

func update_score(newScore):
	score = newScore
	$Hud/Panel/Label.text = "Score: " + str(score)

func reset_apple_position():
	$Apple.position = Vector2(1 + randi() % 19, 1 + randi() % 19) * 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("up"):
		start_game()
	
func start_game():
	$Hud.start_game()
	$Snake.start_game()
	
func game_over():
	get_tree().paused = true
	$GameOverScreen.show()
	
func reset():
	update_score(0)
	reset_apple_position()
	$Snake.reset()
	$GameOverScreen.hide()
	get_tree().paused = false
	
func _on_apple_area_entered(_area):
	reset_apple_position()	
	$Snake.add_segment_on_next_tick = true
	score += 1
	update_score(score)
	
func _on_snake_self_hit():
	game_over()

func _on_game_over_screen_restart():
	reset() # Replace with function body.
