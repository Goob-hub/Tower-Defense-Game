extends Node2D
class_name FireEffectComponent

@onready var timer = $Timer

var data = {
	"name": "", 
	"component": "",
	"duration": "",
	"base_damage": "",
	"stacks_applied": "",
}

var status_effect_manager: StatusEffectManager
var unit_affected: Unit

func _ready():
	timer.timeout.connect(on_timer_timeout)
	if(!data.duration):
		printerr("Fire data not recieved properly")
		pass
	timer.wait_time = data.duration
	timer.start()


func on_timer_timeout():
	var total_damage = data.base_damage * data.stacks_applied
	
	unit_affected.health_component.damage(total_damage)
	status_effect_manager.remove_status_effect(data.name)
	
	self.queue_free()


func handle_duplicate_status_effect(fire_effect: FireEffect):
	data.stacks_applied += fire_effect.stacks_applied
	
	if(data.base_damage < fire_effect.base_damage):
		data.base_damage = fire_effect.base_damage
