extends StatusEffect
class_name PoisonEffect

@export var damage: float
@export var duration: float
@export var time_until_damage: float
@export var stack_duration_potency: float = .1

var status_effect_data

func set_data():
	status_effect_data = {
		"name": self.name,
		"component": self.component,
		"damage": self.damage,
		"duration": self.duration,
		"stack_duration_potency": self.stack_duration_potency,
		"time_until_damage": self.time_until_damage
	}
