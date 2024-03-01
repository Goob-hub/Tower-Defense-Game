extends Resource
class_name StatusEffect

@export var name: String
@export var component: PackedScene
@export_range(0, 1) var chance_to_apply : float = 1
