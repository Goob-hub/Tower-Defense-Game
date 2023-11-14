extends Area2D
class_name Hitbox_component

@export var health_component: HealthComponent

func _ready():
	self.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	print(other_area)
	if(other_area is Attack):
		health_component.damage(other_area.damage)
		print(other_area.damage)
		print(health_component.current_health)

