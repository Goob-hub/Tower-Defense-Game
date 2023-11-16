extends CharacterBody2D

@onready var attack_component = $AttackComponent
@onready var attack_range_component = $AttackRangeComponent
@onready var hitbox_component = $HitboxComponent
@onready var health_component = $HealthComponent
@onready var velocity_component = $VelocityComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var unit_type
var direction

func _ready():
	if(unit_type == "player_unit"):
		direction = Vector2.RIGHT
	else:
		scale.x *= -1
		direction = Vector2.LEFT
	
	health_component.dead.connect(on_dead)
	attack_range_component.start_attack.connect(on_attack_start)
	attack_range_component.stop_attack.connect(on_attack_stop)
	
	animation_player.play("run")
	set_collision_layers_and_masks()


func _process(_delta):
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)


func on_dead():
	hitbox_component.disable_hitbox()
	velocity_component.stop_moving()
	attack_component.stop_attacking()
	attack_range_component.disable_attack_range()
	
	animation_player.play("death")


func on_attack_start():
	velocity_component.stop_moving()
	attack_component.start_attacking()
	
	animation_player.stop()
	animation_player.play("flame")


func on_attack_stop():
	velocity_component.start_moving()
	attack_component.stop_attacking()
	
	animation_player.stop()
	animation_player.play("run")


func set_collision_layers_and_masks():
	
	if(unit_type == "player_unit"):
		hitbox_component.set_collision_mask_value(5, true)
		hitbox_component.set_collision_layer_value(1, true)
		attack_range_component.set_collision_mask_value(2, true)
		attack_component.set_collision_layer_value(4, true)
		self.set_collision_layer_value(1, true)
	
	if(unit_type == "enemy_unit"):
		hitbox_component.set_collision_mask_value(4, true)
		hitbox_component.set_collision_layer_value(2, true)
		attack_range_component.set_collision_mask_value(1, true)
		attack_component.set_collision_layer_value(5, true)
		self.set_collision_layer_value(2, true)
