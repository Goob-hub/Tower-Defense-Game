extends MarginContainer

@export var selected_units: Array[PackedScene] 

@onready var button_container = %ButtonContainer

var summon_button = preload("res://scenes/ui/in_game_ui/unit_summon_button.tscn")

func _ready():
	
	for ui_button in button_container.get_children():
		ui_button.queue_free()
	
	for unit_scene in selected_units:
		var unit = unit_scene.instantiate() as Unit 
		var summon_button_scene = summon_button.instantiate() as UnitSummonButton
		
		summon_button_scene.cooldown = unit.cooldown
		summon_button_scene.mana_cost = unit.mana_cost
		summon_button_scene.unit_icon = unit.unit_icon
		summon_button_scene.unit_scene = unit_scene
		
		button_container.add_child(summon_button_scene)
