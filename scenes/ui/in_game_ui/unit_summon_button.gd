extends Control

@export var unit_scene: PackedScene
@export var unit_image: Texture

@onready var interact_button = %InteractButton
@onready var sprite = $PanelContainer/UnitImage
@onready var mana_cost_label = %ManaCost
@onready var cooldown_timer = $CooldownTimer

var cooldown: float = 10
var mana_cost: float = 30

func _ready():
	sprite.texture = unit_image
	mana_cost_label.text = str(mana_cost)
	cooldown_timer.wait_time = cooldown
	
	cooldown_timer.timeout.connect(on_timer_timeout)
	interact_button.pressed.connect(on_button_pressed)


func on_timer_timeout():
	interact_button.disabled = false


func on_button_pressed():
	var unit_instance = unit_scene.instantiate()
	unit_instance.global_position = Vector2(100, 100)
	get_tree().get_first_node_in_group("player_units_layer").add_child(unit_instance)
	
	interact_button.disabled = true
	cooldown_timer.start()
