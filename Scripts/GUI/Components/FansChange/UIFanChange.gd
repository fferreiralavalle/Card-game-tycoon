extends Control

class_name UIFanChange

@export var icon: TextureRect
@export var label: Label
@export var amount: Label
@export var increase_color: Color
@export var decrease_color: Color
@export var destroy_after: float = 5

func init(fan_change: FansChange):
	label.text = fan_change.name
	amount.text = str(fan_change.amount)
	if (fan_change.amount >= 0):
		amount.add_theme_color_override("font_color", increase_color)
	else:
		amount.add_theme_color_override("font_color", decrease_color)

func _ready() -> void:
	await get_tree().create_timer(destroy_after).timeout
	queue_free()
