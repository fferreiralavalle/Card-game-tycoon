extends Node

class_name UIFansChangeList

@export var list_container: Control
@export var fan_change_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIFanChange:
			push_error("Assigned scene must inherit from UIFanChange!")
		else:
			fan_change_prefab = value

func _ready() -> void:
	CompanyManager.instance.on_fans_changed.connect(add_fan_change)

func add_fan_change(fan_change: FansChange, new_amount: int):
		var fan_change_ui = fan_change_prefab.instantiate() as UIFanChange
		fan_change_ui.init(fan_change)
		list_container.add_child(fan_change_ui)

func remove_finished_activity(finished_mechanic: Mechanic):
	for node in list_container.get_children():
		var activity_set_mechanic = node as UIMechanicInDevelopment
		if (activity_set_mechanic.activity.mechanic == finished_mechanic):
			node.queue_free()
			break;
