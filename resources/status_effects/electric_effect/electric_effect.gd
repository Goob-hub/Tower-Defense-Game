extends StatusEffect
class_name ElectricEffect

@export var chance_to_apply: float
@export var base_damage: float
@export var total_pulses: float
@export var time_until_pulse: float

var status_effect_data = {}

func set_data():
	status_effect_data = {
		"name": self.name,
		"component": self.component,
		"base_damage": self.base_damage,
		"total_pulses": self.total_pulses,
		"time_until_pulse": self.time_until_pulse
	}

func change_effect_data(new_effect_data: Dictionary):
	self.base_damage = new_effect_data.base_damage
	self.total_pulses = new_effect_data.total_pulses
	self.time_until_pulse = new_effect_data.time_until_pulse
