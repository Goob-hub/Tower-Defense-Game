extends ProgressBar

var fuel_manager


func _ready():
	fuel_manager = get_tree().get_first_node_in_group("arrow_fuel_manager") as ArrowFuelManager
	fuel_manager.fuel_updated.connect(on_fuel_updated)


func on_fuel_updated(current_fuel: float, max_fuel: float):
	var fuel_percent = (current_fuel / max_fuel)
	self.value = fuel_percent
