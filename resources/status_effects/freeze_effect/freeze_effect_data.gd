extends StatusEffect
class_name FreezeEffect

@export var amount_percent: float
@export var decrease_percent: float

var data

func set_data():
	data = {
		"name": self.name,
		"component": self.component,
		"amount_percent": self.amount_percent,
		"decrease_percent": self.decrease_percent
	}
