extends Node
class_name ManaManager

@export var max_mana: float = 1000
@export var mana_regen_rate: float = .5
@export var mana_regen_amount: float = 5
@export var starting_mana_amount: float = 0

@onready var mana_regen_timer: Timer = $ManaRegenTimer

var cur_mana_amount: float

func _ready():
	cur_mana_amount = starting_mana_amount
	
	mana_regen_timer.timeout.connect(_on_mana_regen)
	mana_regen_timer.start()


func use_mana(mana_used: float) -> void:
	cur_mana_amount = maxf(cur_mana_amount - mana_used, 0)


func _on_mana_regen() -> void:
	cur_mana_amount = minf(cur_mana_amount + mana_regen_amount, max_mana)
