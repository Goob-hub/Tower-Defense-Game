extends Node2D
class_name FreezeEffectComponent

@onready var timer = $Timer

var current_freeze_percent: float
var data: Dictionary = {}
var status_effect_manager: StatusEffectManager
var unit_affected: Unit

func _ready():
	timer.timeout.connect(on_timer_timeout)
	unit_affected.health_component.dead.connect(on_unit_dead)
	
	if(data.size() <= 0):
		printerr("Freeze data not recieved")
		pass
	
	timer.wait_time = data.DECREASE_INTERVAL
	timer.start()
	
	unit_affected.velocity_component.speed_multiplier = current_freeze_percent
	current_freeze_percent += data.increase_percent


func on_unit_dead():
	delete_self()


func on_timer_timeout() -> void:
	current_freeze_percent -= data.DECREASE_PERCENT
	
	if(current_freeze_percent <= 0):
		delete_self()
	
	unit_affected.velocity_component.speed_multiplier = 1 - (current_freeze_percent * data.MAX_SPEED_PENALTY)


func handle_duplicate_status_effect(freeze_effect: FreezeEffect) -> void:
	current_freeze_percent = minf(freeze_effect.increase_percent + current_freeze_percent, 1)
	unit_affected.velocity_component.speed_multiplier = 1 - (current_freeze_percent * data.MAX_SPEED_PENALTY)


func delete_self():
	timer.stop()
	unit_affected.velocity_component.speed_multiplier = 1
	status_effect_manager.remove_status_effect(data.name)
	self.queue_free()
