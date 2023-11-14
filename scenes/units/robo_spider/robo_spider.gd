extends CharacterBody2D

@onready var health_component = $HealthComponent as HealthComponent
@onready var velocity_component = $VelocityComponent as VelocityComponent
@onready var hit_box_component = $HitboxComponent as Hitbox_component
@onready var attack_manager_component = $AttackManagerComponent as AttackManagerComponent
@onready var attack_component = %AttackComponent as Attack

@onready var attack_range_area: Area2D = %AttackRangeArea
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
	attack_manager_component.start_attack.connect(on_attack_start)
	attack_manager_component.stop_attack.connect(on_attack_stop)
	
	animation_player.play("walk")
	set_collision_layers_and_masks()


func _process(delta):
	velocity_component.accelerate_in_direction(direction, delta)
	velocity_component.move(self)


func on_dead():
	animation_player.play("death")


func set_collision_layers_and_masks():
	if(unit_type == "player_unit"):
		hit_box_component.set_collision_mask_value(5, true)
		hit_box_component.set_collision_layer_value(1, true)
		attack_range_area.set_collision_mask_value(2, true)
		attack_component.set_collision_layer_value(4, true)
		self.set_collision_layer_value(1, true)
	elif(unit_type == "enemy_unit"):
		hit_box_component.set_collision_mask_value(4, true)
		hit_box_component.set_collision_layer_value(2, true)
		attack_range_area.set_collision_mask_value(1, true)
		attack_component.set_collision_layer_value(5, true)
		self.set_collision_layer_value(2, true)


func on_attack_start():
	velocity_component.stop_moving()
	animation_player.stop()
	animation_player.play("blind")


func on_attack_stop():
	velocity_component.start_moving()
	animation_player.stop()
	animation_player.play("walk")
