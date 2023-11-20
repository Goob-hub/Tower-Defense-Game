extends Node2D

@export var arrow_type: PackedScene
@export var rotation_speed: int = 10
@export var fire_rate: float = .5

@onready var fire_rate_timer = $FireRateTimer
@onready var sprite = $Sprite2D

var shoot_button: Button
var projectiles_layer: Node2D 
var fuel_manager: ArrowFuelManager

var force_applied_to_arrow:float = 0 
var is_shooting_arrows:bool = false

func _ready():
	#Probably just check meta progression to update arrow launchers max capacity.
	fire_rate_timer.wait_time = fire_rate
	
	shoot_button = get_tree().get_first_node_in_group("start_launcher_button") as Button
	projectiles_layer = get_tree().get_first_node_in_group("projectiles_layer") as Node2D
	fuel_manager = get_tree().get_first_node_in_group("arrow_fuel_manager") as ArrowFuelManager
	
	shoot_button.pressed.connect(on_pressed)
	fire_rate_timer.timeout.connect(on_timer_timeout)


func _process(_delta):
	if (Input.is_action_just_pressed("aim_up") and self.rotation_degrees > -60):
		self.rotation_degrees -= rotation_speed 
		force_applied_to_arrow += 10
	elif (Input.is_action_just_pressed("aim_down") and self.rotation_degrees < 80):
		self.rotation_degrees += rotation_speed
		force_applied_to_arrow -= 10


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
		arrow.base_velocity += force_applied_to_arrow
		projectiles_layer.add_child(arrow)
