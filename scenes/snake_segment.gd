extends Area2D

signal screen_exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	screen_exited.emit()
