class_name Activity

var employees: Array[Employee] = []

signal on_activity_finished()

func get_progress() -> float:
	return 0

func is_finished() -> bool: return get_progress() >= 1

func _init(_employees: Array[Employee] = []):
	employees = _employees

func handle_weeks_passed(_weeksPassed: int):
	return

func handle_finish():
	on_activity_finished.emit()
	return

func get_employees() -> Array[Employee]:
	return employees

func get_activity_id() -> String: return ""
