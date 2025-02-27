extends BaseButton

class_name UIEmployeeItem

@export var button: BaseButton
@export var setNameLabel: Label
@export var design_level: Label
@export var art_level: Label
@export var lore_level: Label


var employee: Employee

signal onClick(employee: Employee)

func _ready() -> void:
	button.pressed.connect(HandleClick)

func HandleClick():
	onClick.emit(employee)

func Init(_employee: Employee) -> void:
	employee = _employee
	setNameLabel.text = _employee.name + " " + employee.lastName
	design_level.text = str(employee.creationStats.designLevel.level)
	art_level.text = str(employee.creationStats.artLevel.level)
	lore_level.text = str(employee.creationStats.loreLevel.level)
