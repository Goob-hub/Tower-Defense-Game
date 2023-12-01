extends ProgressBar

@export var health_component: HealthComponent

var health_bar_color: Color

func _ready():
	self.value = 1
	health_component.damaged.connect(on_damaged)
	health_component.dead.connect(on_dead)


func on_damaged(_damage_amount: float) -> void:
	var health_percent: float = health_component.current_health / health_component.max_health
	self.value = health_percent
	
	if(health_percent > .5):
		_set_new_style_box(Color("00f052"))
	elif(health_percent < .5 and health_percent > .25):
		_set_new_style_box(Color("d0d100"))
	elif(health_percent < .25 and health_percent > 0):
		_set_new_style_box(Color("e80020"))


func on_dead() -> void:
	self.queue_free()


func _set_new_style_box(color: Color) -> void:
	var style_box = StyleBoxFlat.new()
	self.add_theme_stylebox_override("fill", style_box)
	style_box.bg_color = color
