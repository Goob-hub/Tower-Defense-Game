extends StaticBody2D

@onready var health_component = $HealthComponent as HealthComponent


func _ready():
	health_component.dead.connect(on_dead)


func on_dead():
	queue_free()
