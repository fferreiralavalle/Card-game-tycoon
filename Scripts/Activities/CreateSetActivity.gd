extends Activity

class_name CreateSetActivity

var active_set: Set
var stress_per_week: float = 1
var baseProgress: float = 1

var progress: float = 0;

static var id = "Create_Set"

signal on_set_finished(newSet: Set)

func _init(_set: Set, _employees: Array[Employee]):
	super._init(_employees)
	active_set = _set

func handle_weeks_passed(_weeksPassed: int):
	var stats = active_set.stats
	var goal_stats = active_set.goalStats
	var progressGained: SetCreationStats = get_emploees_creation_stats()
	var design_finish_buff: float = progressGained.design * 0.2 if stats.design >= goal_stats.design else 0.0
	var art_finish_buff: float = progressGained.art * 0.2 if stats.art >= goal_stats.art else 0.0
	var lore_finish_buff: float = progressGained.lore * 0.2 if stats.lore >= goal_stats.lore else 0.0

	stats.design = min(stats.design + progressGained.design + baseProgress + art_finish_buff + lore_finish_buff, goal_stats.design)
	stats.art = min(stats.art + progressGained.art + baseProgress + design_finish_buff + lore_finish_buff, goal_stats.art)
	stats.lore = min(stats.lore + progressGained.lore + baseProgress + design_finish_buff + art_finish_buff, goal_stats.lore)
	for employee in active_set.employees:
		employee.GainGeneralExp(_weeksPassed)
		employee.AddStress(stress_per_week * randf())

func handle_finish():
	active_set.birthday = TimeManager.instance.weeks_passed
	CompanyManager.instance.get_active_card_game().sets.append(active_set)
	on_set_finished.emit(active_set)

func get_progress() -> float:
	return active_set.GetProgress()

func get_activity_id(): return id

func get_emploees_creation_stats() -> SetCreationStats:
	var progress_stats: SetCreationStats = SetCreationStats.new()
	for employee in active_set.employees:
		progress_stats.design += employee.GetCreationStats().designLevel.level
		progress_stats.art += employee.GetCreationStats().artLevel.level
		progress_stats.lore += employee.GetCreationStats().loreLevel.level 
	return progress_stats
