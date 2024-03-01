extends StatusEffect
class_name FireEffect

@export var duration: float
@export var base_damage: float
@export var stacks_applied: float
@export var time_until_damage: float

var status_effect_data = {}

func set_data():
	status_effect_data = {
		"name": self.name,
		"component": self.component,
		"duration": self.duration,
		"base_damage": self.base_damage,
		"stacks_applied": self.stacks_applied,
		"time_until_damage": self.time_until_damage,
		"chance_to_apply": self.chance_to_apply
	}
