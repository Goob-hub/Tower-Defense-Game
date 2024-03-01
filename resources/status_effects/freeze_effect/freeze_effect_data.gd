extends StatusEffect
class_name FreezeEffect

const DECREASE_INTERVAL: float = .5
const DECREASE_PERCENT: float = .05
const MAX_SPEED_PENALTY: float = .75

@export var increase_percent: float

var status_effect_data

func set_data():
	status_effect_data = {
		"name": self.name,
		"component": self.component,
		"increase_percent": self.increase_percent,
		"DECREASE_PERCENT": self.DECREASE_PERCENT,
		"DECREASE_INTERVAL": self.DECREASE_INTERVAL,
		"MAX_SPEED_PENALTY": self.MAX_SPEED_PENALTY,
		"chance_to_apply": self.chance_to_apply
	}
