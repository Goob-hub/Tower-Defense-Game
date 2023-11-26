extends CharacterBody2D

@onready var attack_component = $AttackComponent as AttackComponent
@onready var attack_range_component = $AttackRangeComponent as AttackRangeComponent
@onready var hitbox_component = $HitboxComponent as Hitbox_component
@onready var health_component = $HealthComponent as HealthComponent
@onready var velocity_component = $VelocityComponent as VelocityComponent

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var unit_type
var direction

func _ready():
	health_component.dead.connect(on_dead)
	attack_range_component.start_attack.connect(on_attack_start)
	attack_range_component.stop_attack.connect(on_attack_stop)
	
	animation_player.play("run")
	set_collision_layers_and_masks()
	set_direction()


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
	
	animation_player.play("Melee attack")


func on_attack_stop():
	velocity_component.start_moving()
	
	animation_player.play("run")


func set_direction():
	if(unit_type == "player_unit"):
		direction = Vector2.RIGHT
	else:
		scale.x *= -1
		direction = Vector2.LEFT


func set_collision_layers_and_masks():
	print(unit_type)
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