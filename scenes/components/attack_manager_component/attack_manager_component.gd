extends Node
class_name AttackManagerComponent 

signal start_attack
signal stop_attack

@export var attack_component: Attack 
@export var attack_range_area:Area2D

var enemies_in_range = 0

func _ready():
	attack_range_area.body_entered.connect(on_body_entered)
	attack_range_area.body_exited.connect(on_body_exited)


func on_body_entered(_other_body):
	enemies_in_range += 1
	
	if(enemies_in_range == 1):
		start_attack.emit()


func on_body_exited(_other_body):
	enemies_in_range -= 1
	
	if(enemies_in_range == 0):
		stop_attack.emit()
