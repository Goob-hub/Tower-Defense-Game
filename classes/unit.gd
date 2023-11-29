extends CharacterBody2D
class_name Unit

@onready var attack_range_component = $AttackRangeComponent as AttackRangeComponent
@onready var attack_component = $AttackComponent as AttackComponent
@onready var hitbox_component = $HitboxComponent as Hitbox_component
@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var health_component = $HealthComponent as HealthComponent

@onready var animation_player = $AnimationPlayer as AnimationPlayer

var unit_type
var direction


func set_direction():
	if(unit_type == "player_unit"):
		direction = Vector2.RIGHT
	else:
		scale.x *= -1
		direction = Vector2.LEFT


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
		self.set_collision_layer_value(2, true)
		attack_range_component.set_collision_mask_value(1, true)
		attack_component.set_collision_layer_value(5, true)