extends Control

class_name UIEmployeeSelector

@export var selected_employees_container: Control
@export var available_employees_container: Control
@export var employeeItemPrafab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIEmployeeItem:
			push_error("Assigned scene must inherit from UIEmployeeItem!")
		else:
			employeeItemPrafab = value

var selected_employees: Array[Employee] = []

func _ready():
	visibility_changed.connect(start_list)

func start_list():
	selected_employees = []
	update_employee_list()

func update_employee_list():
	for node in available_employees_container.get_children():
		node.queue_free()
	for node in selected_employees_container.get_children():
		node.queue_free()

	for employee in selected_employees:
		var employeeUI = employeeItemPrafab.instantiate() as UIEmployeeItem
		selected_employees_container.add_child(employeeUI)
		employeeUI.onClick.connect(ToogleEmployee)
		employeeUI.Init(employee)
	for employee in GetAvailableEmployees():
		var employeeUI = employeeItemPrafab.instantiate() as UIEmployeeItem
		available_employees_container.add_child(employeeUI)
		employeeUI.onClick.connect(ToogleEmployee)
		employeeUI.Init(employee)

func GetAvailableEmployees() -> Array[Employee]:
	var employeesAvailable: Array[Employee] = []
	for employee in CompanyManager.instance.get_available_employees():
		if (!selected_employees.has(employee)):
			employeesAvailable.append(employee)
	return employeesAvailable

func ToogleEmployee(employee: Employee):
	if (selected_employees.has(employee)):
		selected_employees.erase(employee)
	else:
		selected_employees.append(employee)
	update_employee_list()

func get_selected_employees(): return selected_employees
