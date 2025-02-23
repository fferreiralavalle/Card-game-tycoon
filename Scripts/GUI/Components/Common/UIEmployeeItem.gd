extends BaseButton

class_name UIEmployeeItem

@export var button: BaseButton
@export var setNameLabel: Label


var employee: Employee

signal onClick(employee: Employee)

func _ready() -> void:
	button.pressed.connect(HandleClick)

func HandleClick():
	onClick.emit(employee)

func Init(_employee: Employee) -> void:
	employee = _employee
	setNameLabel.text = _employee.name + " " + employee.lastName
