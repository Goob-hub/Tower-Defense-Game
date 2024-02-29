extends Control
class_name UnitSummonButton

@export var unit_scene: PackedScene
@export var unit_icon: Texture

@onready var interact_button = %InteractButton as Button
@onready var unit_image = %UnitImage as Sprite2D
@onready var mana_cost_label = %ManaCost as Label
@onready var cooldown_timer = %CooldownTimer as Timer
@onready var cooldown_progress = %CooldownProgress

var mana_manager: ManaManager
var mana_cost: float = 1
var cooldown: float = 1
var unit_ready: bool = true
var unit_spawn_position: Vector2

func _ready():
	unit_spawn_position = get_tree().get_first_node_in_group("player_unit_spawn").global_position
	mana_manager = get_tree().get_first_node_in_group("mana_manager") as ManaManager
	
	unit_image.texture = unit_icon
	mana_cost_label.text = str(mana_cost)
	cooldown_timer.wait_time = cooldown
	
	cooldown_timer.timeout.connect(on_timer_timeout)
	interact_button.pressed.connect(summon_unit)


func _process(_delta):
	var cooldown_percent_left = cooldown_timer.time_left / cooldown_timer.wait_time
	cooldown_progress.value = cooldown_percent_left


func on_timer_timeout():
	unit_ready = true
	interact_button.disabled = false


func summon_unit():
	if(!mana_manager.use_mana(mana_cost) or unit_ready == false):
		return
	
	var unit_instance = unit_scene.instantiate() as Unit
	unit_instance.global_position = unit_spawn_position
	unit_instance.unit_type = "player_unit"
	get_tree().get_first_node_in_group("player_units_layer").add_child(unit_instance)
	
	interact_button.disabled = true
	unit_ready = false
	cooldown_timer.start()
