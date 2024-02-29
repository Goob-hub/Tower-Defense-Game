extends Node
class_name ManaManager

@export var max_mana: float = 1000
@export var mana_regen_rate: float = .5
@export var mana_regen_amount: float = 5
@export var starting_mana_amount: float = 0
@export var starting_mana_level: int = 0
@export var max_mana_level: int = 3
@export var upgrade_multiplier: float = .25
@export var upgrade_cost: float = 150

@onready var mana_regen_timer: Timer = $ManaRegenTimer

var cur_mana_amount: float
var cur_mana_level: float = 0
var stat_multiplier: float = 1

#Base stats
var base_max_mana: float
var base_regen_rate: float
var base_regen_amount: float

var mana_amount_label: Label
var mana_level_label: Label
var mana_upgrade_button: Button

func _ready():
	mana_amount_label = get_tree().get_first_node_in_group("mana_amount_label") as Label
	mana_level_label = get_tree().get_first_node_in_group("mana_level_label") as Label
	mana_upgrade_button = get_tree().get_first_node_in_group("mana_upgrade_button") as Button
	
	cur_mana_amount = starting_mana_amount
	
	mana_regen_timer.timeout.connect(_on_mana_regen)
	mana_upgrade_button.pressed.connect(level_up_mana)
	
	base_max_mana = max_mana
	base_regen_amount = mana_regen_amount
	base_regen_rate = mana_regen_rate
	cur_mana_level = starting_mana_level
	
	_set_mana_regen_timer()
	_update_mana_upgrade_button()
	_update_mana_amount_label()
	_update_mana_level_label()


func _process(_delta):
	if(Input.is_action_just_pressed("upgrade_mana")):
		level_up_mana()


func use_mana(mana_used: float) -> bool:
	if(cur_mana_amount < mana_used):
		return false
	
	cur_mana_amount = maxf(cur_mana_amount - mana_used, 0)
	_update_mana_amount_label()
	
	return true


func gain_mana(mana_amount: float) -> void:
	cur_mana_amount = minf(cur_mana_amount + mana_amount, max_mana)
	_update_mana_amount_label()


func level_up_mana() -> void:
	if(cur_mana_level >= max_mana_level or !use_mana(upgrade_cost)):
		return
	
	stat_multiplier += upgrade_multiplier
	upgrade_cost += roundf(upgrade_cost * upgrade_multiplier)
	
	cur_mana_level += 1
	
	_update_mana_stats()
	_update_mana_amount_label()
	_update_mana_level_label()
	_update_mana_upgrade_button()


func _on_mana_regen() -> void:
	cur_mana_amount = minf(cur_mana_amount + mana_regen_amount, max_mana)
	_update_mana_amount_label()


func _update_mana_amount_label() -> void:
	mana_amount_label.text = "Mana: " + str(roundf(cur_mana_amount)) + " / " + str(roundf(max_mana))


func _update_mana_level_label() -> void:
	mana_level_label.text = "Current level: " + str(cur_mana_level) + " / " + str(max_mana_level)


func _update_mana_upgrade_button() -> void:
	if(cur_mana_level < max_mana_level):
		mana_upgrade_button.text = "Upgrade cost: " + str(roundf(upgrade_cost))
	else:
		mana_upgrade_button.text = "MAX LEVEL"


func _update_mana_stats() -> void:
	max_mana = roundf(base_max_mana * stat_multiplier)
	mana_regen_amount = base_regen_amount * stat_multiplier
	#Formula here gets new wait time by using the multiplier time the current level
	mana_regen_rate -= maxf(base_regen_rate * (upgrade_multiplier * cur_mana_level), .1)


func _set_mana_regen_timer() -> void:
	mana_regen_timer.wait_time = mana_regen_rate
	
	if(mana_regen_timer.is_stopped()):
		mana_regen_timer.start()
