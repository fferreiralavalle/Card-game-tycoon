extends Node  # A singleton is usually a Node, but it can be RefCounted too.

class_name TimeManager  # Optional: Allows type hints for this class

@export var timeInterval: float = 1
@export var weekInterval: float = 4
@export var isTimePassing: bool = false

static var instance: TimeManager
static var weeks_per_month = 4

var _time_passed: float = 0;
var _time_passed_weeks: float = 0;
var speed_multiplier: float = 1

var weeks_passed: int = 0;

signal on_time_passed(timePassed: float)
signal on_weeks_passed(weeks: int)
signal on_months_passed(months: int)

func _init():
	instance = self;
	speed_multiplier = 2
	on_weeks_passed.connect(check_for_month_passed)

func IsTimePassing():
	return isTimePassing && !WindowManager.instance.has_active_windows()

func get_months_passed() -> int:
	return weeks_passed / 4

func check_for_month_passed(weeks: int):
	var current_months = get_months_passed()
	var previous_months = (weeks_passed - weeks) / weeks_per_month
	var months_passed = current_months - previous_months
	if (months_passed > 0):
		on_months_passed.emit(months_passed)

func _process(delta: float) -> void:
	delta *= speed_multiplier
	if (IsTimePassing()):
		_time_passed+= delta;
		_time_passed_weeks += delta
		if (_time_passed >= timeInterval):
			on_time_passed.emit(_time_passed / timeInterval)
			_time_passed -= fmod(_time_passed, timeInterval)
		if (_time_passed_weeks >= weekInterval):
			weeks_passed += 1
			on_weeks_passed.emit(_time_passed_weeks / weekInterval)
			_time_passed_weeks = fmod(_time_passed_weeks, weekInterval)

func get_age(birth_week: int): return weeks_passed - birth_week;
