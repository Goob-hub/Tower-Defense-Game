extends Unit

func _ready():
	health_component.dead.connect(on_dead)
	attack_range_component.start_attack.connect(on_attack_start)
	attack_range_component.stop_attack.connect(on_attack_stop)
	
	animation_player.play("walk")
	set_collision_layers_and_masks()
	set_direction()


func _process(_delta):
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)


func on_dead():
	hitbox_component.disable_hitbox()
	velocity_component.stop_moving()
	attack_range_component.disable_attack_range()
	attack_component.stop_attacking()
	
	animation_player.play("death")


func on_attack_start():
	velocity_component.stop_moving()
	attack_component.start_attacking()
	
	animation_player.stop()
	animation_player.play("blind")


func on_attack_stop():
	velocity_component.start_moving()
	attack_component.stop_attacking()
	
	animation_player.stop()
	animation_player.play("walk")
