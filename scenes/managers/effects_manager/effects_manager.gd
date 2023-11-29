extends Node2D
class_name StatusEffectManager

var cur_status_effects: Dictionary = {}
var cur_unit: Unit

func _ready():
	cur_unit = get_parent() as Unit


func handle_status_effects(status_effects: Array):
	for status_effect in status_effects:
		if(!cur_status_effects.has(status_effect.name)):
			_add_status_effect_data(status_effect)
		else:
			_handle_duplicate_status_effects(status_effect)


func remove_status_effect(status_effect_name: String):
	cur_status_effects.erase(status_effect_name)


func _handle_duplicate_status_effects(status_effect: StatusEffect):
	for status_effect_component in get_children():
		if(status_effect_component is FireEffectComponent and status_effect is FireEffect):
			status_effect_component.handle_duplicate_status_effect(status_effect as FireEffect)


func _add_status_effect_data(status_effect):
	var status_effect_component = status_effect.component.instantiate()
	
	cur_status_effects[status_effect.name] = status_effect.data
	
	status_effect_component.data = status_effect.data
	status_effect_component.unit_affected = cur_unit
	status_effect_component.status_effect_manager = self
	
	self.add_child(status_effect_component)
