extends Camera2D

var left_bound
var right_bound
var mouse_start_pos
var screen_start_position

var dragging = false


func _ready():
	left_bound = get_tree().get_first_node_in_group("left_bound").global_position.x
	right_bound = get_tree().get_first_node_in_group("right_bound").global_position.x
	
	self.limit_left = left_bound
	self.limit_right = right_bound

func _input(event):
	if event.is_action("drag"):
		if event.is_pressed():
			mouse_start_pos = event.global_position.x
			screen_start_position = global_position.x
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position.x = zoom.x * (mouse_start_pos - event.global_position.x) + screen_start_position
