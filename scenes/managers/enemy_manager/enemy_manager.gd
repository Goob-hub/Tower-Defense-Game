extends Node

@onready var timer: Timer = $Timer
@export var enemies: Array[PackedScene] = []
@export var max_time_between_summons: float = 10
@export var min_time_between_summons: float = 7

var spawn_pos: Vector2

func _ready():
	timer.wait_time = randf_range(min_time_between_summons, max_time_between_summons)
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	
	spawn_pos = get_tree().get_first_node_in_group("enemy_unit_spawn").global_position
	
	spawn_random_enemy()


func spawn_random_enemy() -> void:
	if(enemies.size() == 0):
		printerr("There are no enemies in the enemy array to choose from. Fill it up you dingus")
		return

	var enemy_instance = enemies.pick_random().instantiate() as Unit
	enemy_instance.unit_type = "enemy_unit"
	enemy_instance.global_position = spawn_pos

	get_tree().get_first_node_in_group("enemy_units_layer").add_child(enemy_instance)


func on_timer_timeout() -> void:
	spawn_random_enemy()
