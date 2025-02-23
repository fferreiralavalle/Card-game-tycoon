extends Node

class_name ActivityManager

static var instance: ActivityManager

var active_activities: Array[Activity]

signal on_activity_started(activity: Activity)
signal on_activity_finished(activity: Activity)

func start_activity(activity: Activity):
	active_activities.append(activity)
	on_activity_started.emit(activity)

func _init():
	instance = self;

func _ready() -> void:
	TimeManager.instance.on_weeks_passed.connect(handle_weeks_passed)

func handle_weeks_passed(weeksPassed: int):
	var new_active_activities: Array[Activity] = []
	for activity in active_activities:
		activity.handle_weeks_passed(weeksPassed)
		if (activity.is_finished()):
			activity.handle_finish()
			on_activity_finished.emit(activity)
		else:
			new_active_activities.append(activity)
	active_activities = new_active_activities

func get_activities_by_id(id: String) -> Array[Activity]:
	var found_activities: Array[Activity] = []
	for activity in active_activities:
		if (activity.get_activity_id() == id):
			found_activities.append(activity)
	return found_activities

func get_activities_by_class_name(target_class: String):
	return Utils.get_objects_by_class(active_activities, target_class)

func get_busy_employees() -> Array[Employee]:
	var busy_employees: Array[Employee] = []
	for activity in active_activities:
		for employee in activity.get_employees():
			if (!busy_employees.has(employee)):
				busy_employees.append(employee)
	return busy_employees
		
		
