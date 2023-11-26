extends Line2D
class_name TrajectoryLine

func update_trajectory(direciton: Vector2, speed: float, gravity: float, delta: float) -> void:
	var max_points = 300
	clear_points()
	var pos: Vector2 = Vector2.ZERO
	var velocity = direciton * speed
	
	for i in max_points:
		add_point(pos)
		velocity.y += gravity * 2 * delta
		pos += velocity * delta
