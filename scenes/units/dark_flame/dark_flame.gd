extends CharacterBody2D


@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent
@export var hit_box_component: Hitbox_component

var animation_player
var direction

func _ready():
	health_component.dead.connect(on_dead)


func _enter_tree():
	animation_player = $AnimationPlayer
	
	if(get_parent().is_in_group("player_units_layer")):
		direction = Vector2.RIGHT
		hit_box_component.set_collision_detection("player")
	elif(get_parent().is_in_group("enemy_units_layer")):
		direction = Vector2.LEFT
		hit_box_component.set_collision_detection("enemy")
	
	animation_player.play("run")


func _process(delta):
	velocity_component.accelerate_in_direction(direction, delta)
	velocity_component.move(self)


func on_dead():
	animation_player.play("death")
