extends Node2D
class_name StatusEffectManager

var cur_status_effects: Dictionary = {}
var unit_affected: Unit

func _ready():
	unit_affected = get_parent() as Unit


func handle_status_effects(status_effects: Array[StatusEffect]) -> void:
	for status_effect in status_effects:
		if(!cur_status_effects.has(status_effect.name) and roll_effect_chance(status_effect)):
			_add_status_effect_data(status_effect as StatusEffect)
		else:
			_handle_duplicate_status_effects(status_effect)


func roll_effect_chance(status_effect: StatusEffect) -> bool:
	if(status_effect.chance_to_apply >= 1):
		return true
	
	var rand_num = randf()
	
	if(rand_num > status_effect.chance_to_apply):
		return false
	else:
		return true


func remove_status_effect(status_effect_name: String) -> void:
	cur_status_effects.erase(status_effect_name)


func on_unit_dead():
	self.queue_free()


func _add_status_effect_data(status_effect: StatusEffect) -> void:
	var status_effect_component = status_effect.component.instantiate()
	
	cur_status_effects[status_effect.name] = status_effect.status_effect_data
	
	status_effect_component.status_effect_data = status_effect.status_effect_data
	status_effect_component.unit_affected = unit_affected
	status_effect_component.status_effect_manager = self
	status_effect_component.base_status_effect = status_effect
	
	self.call_deferred("add_child", status_effect_component)


func _handle_duplicate_status_effects(status_effect: StatusEffect) -> void:
	for status_effect_component in get_children():
		if(status_effect_component is FireEffectComponent and status_effect is FireEffect):
			status_effect_component.handle_duplicate_status_effect(status_effect as FireEffect)
		
		if(status_effect_component is PoisonEffectComponent and status_effect is PoisonEffect):
			status_effect_component.handle_duplicate_status_effect(status_effect as PoisonEffect)
		
		if(status_effect_component is FreezeEffectComponent and status_effect is FreezeEffect):
			status_effect_component.handle_duplicate_status_effect(status_effect as FreezeEffect)
		
		if(status_effect_component is ElectricEffectComponent and status_effect is ElectricEffect):
			pass
