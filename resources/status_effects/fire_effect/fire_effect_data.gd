extends StatusEffect
class_name FireEffect

@export var duration: float
@export var base_damage: float
@export var stacks_applied: float
@export var time_until_damage: float

var data = {}

func set_data():
	data = {
		"name": self.name,
		"component": self.component,
		"duration": self.duration,
		"base_damage": self.base_damage,
		"stacks_applied": self.stacks_applied,
		"time_until_damage": self.time_until_damage
	}
