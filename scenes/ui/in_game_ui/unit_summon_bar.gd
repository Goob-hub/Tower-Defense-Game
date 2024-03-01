extends MarginContainer

@export var selected_units: Array[PackedScene] 

@onready var button_container = %ButtonContainer

var summon_button = preload("res://scenes/ui/in_game_ui/unit_summon_button.tscn")
var unit_buttons: Array[UnitSummonButton] = []

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
		unit_buttons.append(summon_button_scene)
	
	print(unit_buttons)


func _input(event):
	#Checks for any event and converts to a number, if number key is pressed it will return the number of that key
	#Subtracting 1 from the value to get the correct item from an array
	var event_number = event.as_text().to_int() - 1
	
	if(event_number <= unit_buttons.size() - 1 and event_number >= 0 and unit_buttons[event_number].unit_ready):
		unit_buttons[event_number].summon_unit()
