extends Control

class_name UIMechanicSelector

@export var mechanics_container: Control
@export var mechanic_item_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIMechanicItem:
			push_error("Assigned scene must inherit from UIMechanicItem!")
		else:
			mechanic_item_prefab = value

var selected_mechanics: Array[Mechanic] = []

func _ready():
	visibility_changed.connect(start_list)

func start_list():
	selected_mechanics = []
	for node in mechanics_container.get_children():
		node.queue_free()

	for mechanic in CompanyManager.instance.get_active_card_game().mechanics:
		var mechanic_ui = mechanic_item_prefab.instantiate() as UIMechanicItem
		mechanics_container.add_child(mechanic_ui)
		mechanic_ui.on_click.connect(toggle_mechanic)
		mechanic_ui.Init(mechanic)
	update_mechanic_list()

func update_mechanic_list():
	for node in mechanics_container.get_children():
		var mechanic_ui = node as UIMechanicItem
		mechanic_ui.set_selected_state(selected_mechanics.has(mechanic_ui.mechanic))

func toggle_mechanic(mechanic: Mechanic, _toogle_on: bool):
	if (selected_mechanics.has(mechanic)):
		selected_mechanics.erase(mechanic)
	else:
		selected_mechanics.append(mechanic)
	update_mechanic_list()

func get_selected_mechanics(): return selected_mechanics
