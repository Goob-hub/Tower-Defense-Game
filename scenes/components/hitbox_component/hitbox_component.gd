extends Area2D
class_name Hitbox_component

func _ready():
	self.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	pass


func set_collision_detection(unit_type: String):
	if(unit_type == "player"):
		self.set_collision_mask_value(5, true)
	elif(unit_type == "enemy"):
		self.set_collision_mask_value(4, true)
