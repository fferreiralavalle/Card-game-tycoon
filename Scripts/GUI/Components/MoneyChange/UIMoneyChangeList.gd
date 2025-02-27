extends Node

class_name UIMoneyChangeList

@export var list_container: Control
@export var money_change_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIMoneyChange:
			push_error("Assigned scene must inherit from UIFanChange!")
		else:
			money_change_prefab = value

func _ready() -> void:
	CompanyManager.instance.on_money_changed.connect(add_money_change)

func add_money_change(money_change: IncomeInfo, new_amount: float):
	if (money_change.amount != 0):
		var money_change_ui = money_change_prefab.instantiate() as UIMoneyChange
		money_change_ui.init(money_change)
		list_container.add_child(money_change_ui)
