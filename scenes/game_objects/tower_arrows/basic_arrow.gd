extends StaticBody2D
class_name Arrow 

@export var arrow_speed:float = 1200
@export var arrow_damage: float = 20
@export var fuel_cost_per_shot: float = 1
@export var arrow_effects = []
@export var stop_on_ground: bool = true

@onready var attack_component = $AttackComponent as AttackComponent
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var area = $Area2D as Area2D

var pos0: Vector2
var pos1: Vector2
var pos2: Vector2

var is_on_ground = false
var time = 0
var distance: float

func _ready():
	if(stop_on_ground):
		area.body_entered.connect(on_body_entered)
	
	distance = pos2.distance_to(pos0)
	
	attack_component.damage = arrow_damage
	attack_component.status_effects = arrow_effects


func _physics_process(delta):
	if(is_on_ground):
		return
	
	self.global_position = bezier(pos0, pos1, pos2, time)
	time += delta / (distance / arrow_speed)
	
	if(time >= 1):
		is_on_ground = true


func on_body_entered(other_body: Node2D):
	if(other_body.is_in_group("ground")):
		is_on_ground = true
		animation_player.play("fade_out")


func bezier(point_0: Vector2, point_1: Vector2, point_2: Vector2, t: float):
	var q0 = point_0.lerp(point_1, t)
	var q1 = point_1.lerp(point_2, t)
	var r = q0.lerp(q1, t)
	return r
