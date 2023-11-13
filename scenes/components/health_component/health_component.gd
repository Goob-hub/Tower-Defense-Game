extends Node
class_name HealthComponent

signal dead
signal damaged
signal healed

@export var max_health: float

var current_health


func _ready():
	if(max_health == 0):
		printerr("Did not set health for " + owner.name)
		return
	
	current_health = max_health


func damage(damage_amount: float):
	current_health = maxf(0.0, current_health - damage_amount)
	
	if(current_health == 0):
		emit_dead_signal()
	else:
		emit_damaged_signal()


func heal(heal_amount: float):
	current_health = minf(max_health, current_health + heal_amount)


func emit_dead_signal():
	dead.emit()


func emit_damaged_signal():
	damaged.emit()


func emit_healed_signal():
	healed.emit()