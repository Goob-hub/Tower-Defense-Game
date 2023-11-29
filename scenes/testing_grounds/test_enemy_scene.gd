extends Node

@onready var player_units = $Player_units
@onready var enemy_units = $Enemy_units

@export var unit_scene: PackedScene


func _ready():
	spawn_enemy_unit()
	spawn_player_unit()


func spawn_enemy_unit():
	var unit = unit_scene.instantiate() as Unit
	unit.unit_type = "enemy_unit"
	unit.global_position = enemy_units.global_position
	enemy_units.add_child(unit)


func spawn_player_unit():
	var unit = unit_scene.instantiate() as Unit
	unit.unit_type = "player_unit"
	unit.global_position = player_units.global_position
	enemy_units.add_child(unit)
