extends Area2D
class_name Hitbox_component

@export var health_component: HealthComponent
@export var hit_box_shape: CollisionShape2D

func _ready():
	self.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	if(other_area is Attack):
		health_component.damage(other_area.damage)


func disable_hitbox():
	hit_box_shape.set_deferred("disabled", true)


func enable_hitbox():
	hit_box_shape.set_deferred("disabled", false)
