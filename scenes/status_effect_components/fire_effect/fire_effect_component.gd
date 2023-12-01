extends Node2D
class_name FireEffectComponent

@onready var time_until_damage = $TimeUntilDamage
@onready var duration_timer = $DurationTimer

var data: Dictionary
var unit_affected: Unit
var status_effect_manager: StatusEffectManager

func _ready():
	duration_timer.timeout.connect(on_duration_timeout)
	time_until_damage.timeout.connect(on_damage_timeout)
	unit_affected.health_component.dead.connect(on_dead)
	
	if(data.size() <= 0):
		printerr("Fire data not recieved")
		pass
	
	duration_timer.wait_time = data.duration
	time_until_damage.wait_time = data.time_until_damage
	
	time_until_damage.start()
	duration_timer.start()


func on_dead():
	delete_self()


func on_duration_timeout() -> void:
	delete_self()


func on_damage_timeout():
	var damage_dealt = data.base_damage * data.stacks_applied
	
	if(!unit_affected.health_component):
		printerr(unit_affected.name, " Has no health component")
		delete_self()
		return
	
	unit_affected.health_component.damage(damage_dealt)


func handle_duplicate_status_effect(fire_effect: FireEffect) -> void:
	data.stacks_applied += fire_effect.stacks_applied
	
	if(data.base_damage < fire_effect.base_damage):
		data.base_damage = fire_effect.base_damage
	
	if(data.duration < fire_effect.duration):
		data.duration = fire_effect.duration
		duration_timer.start(fire_effect.duration)
	else:
		duration_timer.start(data.duration)


func delete_self():
	status_effect_manager.remove_status_effect(data.name)
	self.queue_free()
