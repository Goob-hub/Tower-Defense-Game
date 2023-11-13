extends Node
class_name VelocityComponent

@export var mov_speed: float
@export var acceleration: float

var velocity = Vector2.ZERO

func accelerate_in_direction(direction: Vector2, delta_time: float):
	var target_velocity = direction * mov_speed
	#Gradually gets to target velocity based on the percent provided
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta_time * acceleration))


func move(character_body: Node2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	#Re-setting the velocity here in the script because move and slide alters the character velocity
	velocity = character_body.velocity
