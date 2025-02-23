extends UISetCreationStep

class_name UISetEmployees

@export var employee_selector: UIEmployeeSelector

func _ready():
	super._ready()

func Init(newSet: Set):
	super.Init(newSet)

func HandleDone():
	currentSet.employees = employee_selector.get_selected_employees()
	super.HandleDone()
