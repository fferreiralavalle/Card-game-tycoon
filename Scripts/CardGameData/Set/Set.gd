class_name Set

var name: String
var general_mechanics: Array[Mechanic]
var employees: Array[Employee]
var stats: SetCreationStats
var goalStats: SetCreationStats
var icon: Texture2D
var reception: SetReception

var progress: float = 0

## The ingame week number this set was born, used to calculate set age
var birthday: int

func _init(_name: String, _icon: Texture2D, _stats: SetCreationStats):
	name = _name
	icon = _icon
	goalStats = _stats
	stats = SetCreationStats.new()
	reception = SetReception.new()

func IsSetFinished() -> bool:
	var isDesignDone = stats.design >= goalStats.design
	var isArtDone = stats.art >= goalStats.art
	var isLoreDone = stats.lore >= goalStats.lore
	return isDesignDone && isArtDone && isLoreDone

func add_bonus_stats():
	# Each mechanic adds more design and lore points
	goalStats.design += general_mechanics.size() * ExpansionConstants.BASE_DESIGN_POINTS_PER_MECHANIC
	goalStats.lore += general_mechanics.size() * ExpansionConstants.BASE_LORE_POINTS_PER_MECHANIC

func GetProgress() -> float:
	var designProgress = clamp(stats.design, 0, goalStats.design)
	var artProgress = clamp(stats.art, 0, goalStats.art)
	var loreProgress = clamp(stats.lore, 0, goalStats.lore)
	var totalProgress = (designProgress + artProgress + loreProgress) / (goalStats.design + goalStats.art + goalStats.lore)
	return totalProgress

func get_average_review_score() -> float:
	if (reception.reviews.size() == 0):
		return 0.7
	return reception.get_average_score()

func get_life_expectancy() -> int:
	var life_expectancy = ExpansionConstants.BASE_EXPANSION_WEEK_DURATION + get_average_review_score() * ExpansionConstants.EXPANSION_DURATION_REVIEW_MULTIPLIER
	return life_expectancy
