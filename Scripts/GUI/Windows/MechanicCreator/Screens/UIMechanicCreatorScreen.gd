extends GameWindow

class_name UIMechanicCreatorScreen

@export var name_input: LineEdit
@export var complexity_label: Label
@export var employee_selector: UIEmployeeSelector
@export var finish: BaseButton

var mechanic: Mechanic
var complexity: float

signal on_finish(mechanic: Mechanic)

func _ready() -> void:
	super._ready()
	finish.pressed.connect(handle_done)

func Init(_mechanic: Mechanic, current_complexity: float):
	mechanic = _mechanic
	complexity = current_complexity
	complexity_label.text = str(current_complexity)

func handle_done():
	mechanic.name = name_input.text
	ActivityManager.instance.start_activity(
		CreateMechanicActivity.new(
			mechanic,
			complexity,
			employee_selector.get_selected_employees()
		)
	)
	on_finish.emit(mechanic)
