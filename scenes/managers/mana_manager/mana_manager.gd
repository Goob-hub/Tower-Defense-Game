extends Node
class_name ManaManager

@export var max_mana: float = 1000
@export var mana_regen_rate: float = .5
@export var mana_regen_amount: float = 5
@export var starting_mana_amount: float = 0

@onready var mana_regen_timer: Timer = $ManaRegenTimer

var cur_mana_amount: float
var mana_label: Label

func _ready():
	mana_label = get_tree().get_first_node_in_group("mana_label") as Label
	cur_mana_amount = starting_mana_amount
	
	mana_regen_timer.timeout.connect(_on_mana_regen)
	mana_regen_timer.wait_time = mana_regen_rate
	mana_regen_timer.start()


func use_mana(mana_used: float) -> bool:
	if(cur_mana_amount < mana_used):
		return false
	
	cur_mana_amount = maxf(cur_mana_amount - mana_used, 0)
	_update_mana_label()
	
	return true


func _on_mana_regen() -> void:
	cur_mana_amount = minf(cur_mana_amount + mana_regen_amount, max_mana)
	_update_mana_label()


func _update_mana_label() -> void:
	mana_label.text = str(cur_mana_amount) + " / " + str(max_mana)
