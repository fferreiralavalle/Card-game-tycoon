extends Control

class_name UIMoneyChange

@export var icon: TextureRect
@export var label: Label
@export var amount: Label
@export var increase_color: Color
@export var decrease_color: Color
@export var destroy_after: float = 2

func init(income_info: IncomeInfo):
	label.text = income_info.name
	amount.text = ("+" if income_info.amount > 0 else "") + "%.0f" % income_info.amount
	if (income_info.amount >= 0):
		amount.add_theme_color_override("font_color", increase_color)
	else:
		amount.add_theme_color_override("font_color", decrease_color)

func _ready() -> void:
	await get_tree().create_timer(destroy_after).timeout
	queue_free()
