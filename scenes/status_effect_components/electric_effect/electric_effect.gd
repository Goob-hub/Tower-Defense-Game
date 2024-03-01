extends Node2D
class_name ElectricEffectComponent

@onready var pulse_timer = $%PulseTimer
@onready var pulse_delay_timer = $%PulseDelayTimer
@onready var effect_area = $%EffectArea
@onready var effect_hitbox = $%ElectricEffectHitbox

var status_effect_data: Dictionary
var unit_affected: Unit
var status_effect_manager: StatusEffectManager
var base_status_effect: StatusEffect 

var pulses_remaining: int

func _ready():
	pulse_timer.timeout.connect(on_pulse_timeout)
	pulse_delay_timer.timeout.connect(on_pulse_delay_timeout)
	effect_area.area_entered.connect(_on_area_entered)
	unit_affected.health_component.dead.connect(on_unit_death)
	
	if(status_effect_data.size() <= 0):
		printerr("Electric effect status_effect_data not recieved properly")
		pass
	
	pulses_remaining = status_effect_data.total_pulses
	
	pulse_timer.wait_time = status_effect_data.time_until_pulse
	pulse_timer.start()
	
	_set_collision_masks()


func on_pulse_timeout() -> void:
	unit_affected.health_component.damage(status_effect_data.base_damage)
	pulses_remaining -= 1
	
	print(pulses_remaining, " : ", unit_affected.health_component.current_health)
	
	if(pulses_remaining <= 0):
		delete_self()
		pass
	
	effect_hitbox.disabled = false
	pulse_delay_timer.start()


func on_pulse_delay_timeout() -> void:
	effect_hitbox.disabled = true
	pulse_timer.start()


func on_unit_death() -> void:
	delete_self()


func delete_self() -> void:
	status_effect_manager.remove_status_effect(status_effect_data.name)
	self.queue_free()


func _set_collision_masks() -> void:
	if(unit_affected.unit_type == "player_unit"):
		effect_area.set_collision_mask_value(1, true)
	
	if(unit_affected.unit_type == "enemy_unit"):
		effect_area.set_collision_mask_value(2, true)


func _on_area_entered(other_area: Area2D) -> void:
	var other_unit = other_area.get_parent() as Unit
	
	if(pulses_remaining > 1):
		var new_effect_data = status_effect_data
		new_effect_data.total_pulses = pulses_remaining
		new_effect_data.chance_to_apply = 1
		
		base_status_effect.status_effect_data = new_effect_data
		
		other_unit.status_effects_manager.handle_status_effects([base_status_effect] as Array[StatusEffect])
