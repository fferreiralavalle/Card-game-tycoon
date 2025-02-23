extends Activity

class_name CreateMechanicActivity

var mechanic: Mechanic
var complexity: float
var stressPerWeek: float = 1

var progress: float = 0;

static var id = "Create_Mechanic"

func _init(_mechanic: Mechanic, _complexity: float, _employees: Array[Employee]):
	super._init(_employees)
	mechanic = _mechanic
	complexity = _complexity

func handle_weeks_passed(_weeksPassed: int):
	for employee in employees:
		progress += employee.GetCreationStats().designLevel.level * _weeksPassed
		progress += employee.GetCreationStats().artLevel.level * _weeksPassed * 0.2
		progress += employee.GetCreationStats().designLevel.level * _weeksPassed * 0.2
		employee.AddStress(stressPerWeek * randf())
		print("Mechanic Progress: ", progress, " complexity: ", complexity)
	return

func get_progress() -> float:
	return clamp(progress / complexity, 0, 1)

func get_activity_id(): return id

func handle_finish():
	CompanyManager.instance.get_active_card_game().mechanics.append(mechanic)
