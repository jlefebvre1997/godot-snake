extends Node

@export var snake_segment: PackedScene

const starting_position = Vector2(9, 9)
var direction = Vector2(0, 0)
var segments: Array
var add_segment_on_next_tick = false
signal self_hit

const up = Vector2(0, -1)
const down = Vector2(0, 1)
const left = Vector2(-1, 0)
const right = Vector2(1, 0)

var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(3):
		add_segment((starting_position + Vector2(0, i)) * 50)
		
	segments[0].screen_exited.connect(_on_screen_exited)
		
func add_segment(pos):
	var segment = snake_segment.instantiate()
	segment.position = pos
	segment.area_entered.connect(_on_self_hit)
	segments.append(segment)
	add_child(segment)
	
func _on_self_hit(_area):
	self_hit.emit()
	
func _on_screen_exited():
	self_hit.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("down") and direction != up:
		update_direction(down)
	elif Input.is_action_just_pressed("up") and direction != down:
		update_direction(up)
	elif Input.is_action_just_pressed("left") and direction != right:
		update_direction(left)
	elif Input.is_action_just_pressed("right") and direction != left:
		update_direction(right)

func update_direction(new_direction: Vector2):
	direction = new_direction
	can_move = false
	
func _on_move_timer_timeout():
	if direction == Vector2(0, 0):
		return
	
	var previous_segment_position = segments[0].position
	segments[0].position += direction * 50
	
	for segment in range(1, segments.size()):
		var old_segment_position = segments[segment].position
		segments[segment].position = previous_segment_position
		previous_segment_position = old_segment_position
		
	if add_segment_on_next_tick:
		add_segment(previous_segment_position)
		add_segment_on_next_tick = false
		
	can_move = true

func start_game():
	$MoveTimer.start()
	direction = up

func reset():
	direction = Vector2(0, 0)
	
	get_tree().call_group("segments", "queue_free")
			
	segments.clear()
	
	_ready()
