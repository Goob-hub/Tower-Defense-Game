extends RigidBody2D
class_name Arrow 

@export var base_velocity: float = 300
@export var arrow_damage: float = 20
@export var fuel_cost_per_shot: float = 5
@export var arrow_effects = []
@export var stop_on_floor: bool = true

@onready var attack_component = $AttackComponent as AttackComponent
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var area = $Area2D as Area2D


var direction = Vector2.RIGHT
var is_on_floor = false
var velocity

func _ready():
	if(stop_on_floor):
		area.body_entered.connect(on_body_entered)
	
	velocity = Vector2(base_velocity, base_velocity) * direction.rotated(deg_to_rad(self.rotation_degrees)).normalized()
	linear_velocity = velocity
	
	attack_component.damage = arrow_damage
	attack_component.status_effects = arrow_effects


func _integrate_forces(_state):
	if(is_on_floor):
		return
	
	linear_velocity.x = base_velocity


func on_body_entered(other_body: Node2D):
	if(other_body.is_in_group("ground")):
		is_on_floor = true
		linear_velocity = Vector2.ZERO
		animation_player.play("fade_out")
