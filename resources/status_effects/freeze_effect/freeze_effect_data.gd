extends StatusEffect
class_name FreezeEffect

@export var increase_percent: float
@export var decrease_percent: float

var data

func set_data():
	data = {
		"name": self.name,
		"component": self.component,
		"increase_percent": self.increase_percent,
		"decrease_percent": self.decrease_percent
	}
