extends Node
class_name ArrowFuelManager

signal fuel_updated(new_fuel_amount: float, max_fuel_amount: float)

@export var max_fuel: float = 100
@export var fuel_regen_rate:float = .5
@export var fuel_regen_amount:float = 1

@onready var timer = $Timer

var current_fuel: float
var can_shoot_arrow: bool = true


func _ready():
	current_fuel = max_fuel
	
	timer.wait_time = fuel_regen_rate
	timer.timeout.connect(on_timer_timeout)
	timer.start()


func decrease_fuel(amount: float):
	current_fuel = maxf(0, current_fuel - amount)
	emit_fuel_updated(current_fuel, max_fuel)


func increase_fuel(amount: float):
	current_fuel = minf(max_fuel, current_fuel + amount)
	emit_fuel_updated(current_fuel, max_fuel)


func can_fire_arrow(fuel_cost: float) -> bool:
	if(current_fuel < fuel_cost):
		return false
	else:
		return true


func emit_fuel_updated(cur_fuel: float, max_fuel_amount: float):
	fuel_updated.emit(cur_fuel, max_fuel_amount)


func on_timer_timeout():
	increase_fuel(fuel_regen_amount)
