extends Node2D
class_name PoisonEffectComponent

@onready var time_until_damage: Timer = $TimeUntilDamage
@onready var duration_timer: Timer = $Duration

var data: Dictionary = {}
var status_effect_manager: StatusEffectManager
var unit_affected: Unit

func _ready():
	time_until_damage.timeout.connect(on_damage_timeout)
	duration_timer.timeout.connect(on_duration_timeout)
	unit_affected.health_component.dead.connect(on_unit_dead)
	
	if(data.size() <= 0):
		printerr("Poison data not recieved")
		pass
	
	time_until_damage.wait_time = data.time_until_damage
	duration_timer.wait_time = data.duration
	
	duration_timer.start()
	time_until_damage.start()


func on_unit_dead():
	delete_self()


func on_duration_timeout() -> void:
	status_effect_manager.remove_status_effect(data.name)
	delete_self()


func on_damage_timeout() -> void:
	if(!unit_affected.health_component):
		printerr(unit_affected, " Has no health component")
		delete_self()
		return
	
	unit_affected.health_component.damage(data.damage)


func handle_duplicate_status_effect(poison_effect: PoisonEffect) -> void:
	var new_duration_time = (poison_effect.duration * poison_effect.stack_duration_potency) + duration_timer.time_left
	
	duration_timer.wait_time = new_duration_time
	duration_timer.start()
	
	if(data.damage < poison_effect.damage):
		data.damage = poison_effect.damage
	
	if(data.time_until_damage < poison_effect.time_until_damage):
		data.time_until_damage = poison_effect.time_until_damage
		time_until_damage.wait_time = poison_effect.time_until_damage


func delete_self():
	status_effect_manager.remove_status_effect(data.name)
	self.queue_free()
