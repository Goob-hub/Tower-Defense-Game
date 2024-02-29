extends Node2D
class_name PoisonEffectComponent

@onready var time_until_damage: Timer = $TimeUntilDamage
@onready var duration_timer: Timer = $Duration

var status_effect_data: Dictionary = {}
var status_effect_manager: StatusEffectManager
var base_status_effect: StatusEffect
var unit_affected: Unit

func _ready():
	time_until_damage.timeout.connect(on_damage_timeout)
	duration_timer.timeout.connect(on_duration_timeout)
	unit_affected.health_component.dead.connect(on_unit_dead)
	
	if(status_effect_data.size() <= 0):
		printerr("Poison status_effect_data not recieved")
		pass
	
	time_until_damage.wait_time = status_effect_data.time_until_damage
	duration_timer.wait_time = status_effect_data.duration
	
	duration_timer.start()
	time_until_damage.start()


func on_unit_dead():
	delete_self()


func on_duration_timeout() -> void:
	delete_self()


func on_damage_timeout() -> void:
	if(!unit_affected.health_component):
		printerr(unit_affected, " Has no health component")
		delete_self()
		return
	
	unit_affected.health_component.damage(status_effect_data.damage)


func handle_duplicate_status_effect(poison_effect: PoisonEffect) -> void:
	var new_duration_time = (poison_effect.duration * poison_effect.stack_duration_potency) + duration_timer.time_left
	
	duration_timer.wait_time = new_duration_time
	duration_timer.start()
	
	if(status_effect_data.damage < poison_effect.damage):
		status_effect_data.damage = poison_effect.damage
	
	if(status_effect_data.time_until_damage < poison_effect.time_until_damage):
		status_effect_data.time_until_damage = poison_effect.time_until_damage
		time_until_damage.wait_time = poison_effect.time_until_damage


func delete_self():
	status_effect_manager.remove_status_effect(status_effect_data.name)
	self.queue_free()
