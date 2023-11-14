extends Node
class_name VelocityComponent

@export var base_mov_speed: float
@export var base_acceleration: float

var velocity = Vector2.ZERO
var altered_mov_speed
var altered_acceleration


func _ready():
	altered_mov_speed = base_mov_speed
	altered_acceleration = base_acceleration


func accelerate_in_direction(direction: Vector2, delta_time: float):
	var target_velocity = direction * altered_mov_speed
	#Gradually builds up to the target velocity based on the percent provided
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta_time * altered_acceleration))


func move(character_body: Node2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	#Re-setting the velocity here in the script because move and slide alters the character velocity
	velocity = character_body.velocity


func stop_moving():
	altered_mov_speed = 0
	altered_acceleration = 100


func start_moving():
	altered_mov_speed = base_mov_speed
	altered_acceleration = base_acceleration
