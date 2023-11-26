extends Node2D
class_name ArrowLauncher

const BASE_CURVE_PEAK_OFFSET: float = 100

@export var arrow_type: PackedScene
@export var arrow_range: float = 1000
@export var rot_amount_deg: int = 4
@export var rotation_increments: int = 12
@export var fire_rate: float = .1

@onready var fire_rate_timer = $FireRateTimer
@onready var sprite = $Sprite2D

@export var p0: Node2D
@export var p1: Node2D 
@export var p2: Node2D 

var shoot_button: Button
var projectiles_layer: Node2D 
var player_tower: Node2D
var ground: Node2D
var fuel_manager: ArrowFuelManager

var is_shooting_arrows:bool = false
var current_peak_offset = 100
var current_range

func _ready():
	shoot_button = get_tree().get_first_node_in_group("start_launcher_button") as Button
	projectiles_layer = get_tree().get_first_node_in_group("projectiles_layer") as Node2D
	fuel_manager = get_tree().get_first_node_in_group("arrow_fuel_manager") as ArrowFuelManager
	player_tower = get_tree().get_first_node_in_group("player_tower") as Node2D
	ground = get_tree().get_first_node_in_group("ground") as Node2D
	
	fire_rate_timer.wait_time = fire_rate
	current_range = arrow_range / 2
	
	shoot_button.pressed.connect(on_pressed)
	fire_rate_timer.timeout.connect(on_timer_timeout)
	
	set_point_positions()


func _process(_delta):
	if (Input.is_action_just_pressed("aim_up") and self.rotation_degrees > -rot_amount_deg * rotation_increments):
		self.rotation_degrees -= rot_amount_deg
		update_point_positions("up")
	elif (Input.is_action_just_pressed("aim_down") and self.rotation_degrees < rot_amount_deg * rotation_increments):
		self.rotation_degrees += rot_amount_deg
		update_point_positions("down")


func on_pressed():
	if(!is_shooting_arrows):
		is_shooting_arrows = true
		shoot_button.text = "Arrows: ON"
		fire_rate_timer.start()
	else:
		is_shooting_arrows = false
		shoot_button.text = "Arrows: OFF"
		fire_rate_timer.stop()


func on_timer_timeout():
	shoot_arrow()


func shoot_arrow():
	var arrow = arrow_type.instantiate() as Arrow
	
	if(fuel_manager.can_fire_arrow(arrow.fuel_cost_per_shot)):
		fuel_manager.decrease_fuel(arrow.fuel_cost_per_shot)
		
		arrow.global_position = sprite.global_position
		arrow.rotation = self.rotation
		arrow.pos0 = p0.global_position
		arrow.pos1 = p1.global_position
		arrow.pos2 = p2.global_position
		projectiles_layer.add_child(arrow)


func set_point_positions():
	p0.global_position = sprite.global_position
	p2.global_position = Vector2(player_tower.global_position.x + current_range, ground.global_position.y)
	
	var mid_point = (p2.global_position + p0.global_position) / 2
	mid_point.y -= current_peak_offset
	p1.global_position = mid_point


func update_point_positions(aim_direction:String):
	var front_of_tower = get_tree().get_first_node_in_group("player_unit_spawn").global_position.x
	var pos_change = (arrow_range / 2) / rotation_increments
	var peak_offset_change = BASE_CURVE_PEAK_OFFSET / rotation_increments
	
	p0.global_position = sprite.global_position
	
	if(aim_direction == "up"):
		p2.global_position.x += pos_change
		current_peak_offset -= peak_offset_change
	else:
		p2.global_position.x -= pos_change
		current_peak_offset += peak_offset_change
	
	if(p2.global_position.x <= front_of_tower):
		p2.global_position.x = front_of_tower
	
	var midpoint = (p2.global_position + p0.global_position) / 2
	midpoint.y = current_peak_offset
	p1.global_position = midpoint
