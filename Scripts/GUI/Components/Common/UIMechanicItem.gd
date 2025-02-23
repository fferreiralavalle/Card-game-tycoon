extends Node

class_name UIMechanicItem

@export var button: CheckButton

var mechanic: Mechanic

signal on_click(mechanic: Mechanic, toggle_on: bool)

func _ready() -> void:
	button.toggled.connect(handle_click)

func handle_click(toogle_on: bool):
	on_click.emit(mechanic, toogle_on)

func set_selected_state(selected: bool):
	button.set_pressed_no_signal(selected)

func Init(mechanic: Mechanic) -> void:
	self.mechanic = mechanic
	button.text = mechanic.name
