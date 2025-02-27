extends Resource

class_name Reviewer

@export var id: String;
@export var name: String
@export var initial_fans: int
@export var growth_per_week: int
@export var money_per_fan: float = 10
## multiplier for expected stats applied each week
@export var weekly_expected_stat_growth_multiplier: float = 0.05
@export var base_expected_creation_stats: SetCreationStats

var fans_pool: FansPool;
var current_expected_creation_stats: SetCreationStats

func get_expected_creation_stats() -> SetCreationStats:
	var weeks_passed: int = TimeManager.instance.weeks_passed
	var multiplier: float = 1 + weekly_expected_stat_growth_multiplier * weeks_passed
	var creation_stats: SetCreationStats = current_expected_creation_stats.duplicate()
	creation_stats.design *= multiplier
	creation_stats.art *= multiplier
	creation_stats.lore *= multiplier

	return creation_stats

## @param review_set: the set to be reviewed.
## @return Returns a score number between 0 and 1.
func get_set_score(review_set: Set) -> float:
	var expected_stats: SetCreationStats = get_expected_creation_stats()
	var set_stats = review_set.stats
	var random_score_multiplier = randf_range(1 - ReviewerConstants.SCORE_VARIANCE, 1 + ReviewerConstants.SCORE_VARIANCE)
	var set_score_base: float = (
		clampf(set_stats.design, 0, expected_stats.design)+
		clampf(set_stats.art, 0, expected_stats.art)+
		clampf(set_stats.lore, 0, expected_stats.lore) + 1
	) / (expected_stats.GetTotalPoints() + 1)
	var set_score_final = clampf(set_score_base * random_score_multiplier, 0, 1)
	print(name, " expected Design ", expected_stats.design, "art: ", expected_stats.art, "lore: ", expected_stats.lore)
	# expectations are adjusted based on score
	if (set_score_final >= ReviewerConstants.LOSE_FANS_SCORE_TRESHOLD):
		current_expected_creation_stats.design *= ReviewerConstants.EXPECTATION_INCREASE_ON_SURPASS
		current_expected_creation_stats.art *= ReviewerConstants.EXPECTATION_INCREASE_ON_SURPASS
		current_expected_creation_stats.lore *= ReviewerConstants.EXPECTATION_INCREASE_ON_SURPASS
		print(
			name, " upped expectations to Design: ",
			current_expected_creation_stats.design,
			" - art: ", current_expected_creation_stats.art,
			" - lore: ", current_expected_creation_stats.lore
		)

	else:
		current_expected_creation_stats.design *= ReviewerConstants.EXPECTATION_DECREASE_ON_FAIL
		current_expected_creation_stats.art *= ReviewerConstants.EXPECTATION_DECREASE_ON_FAIL
		current_expected_creation_stats.lore *= ReviewerConstants.EXPECTATION_DECREASE_ON_FAIL
		print(
			name, " downed expectations to Design: ",
			current_expected_creation_stats.design,
			" - art: ", current_expected_creation_stats.art,
			"- lore: ", current_expected_creation_stats.lore
		)

	return set_score_final

func get_game_fans(game_id: String) -> int:
	return fans_pool.get_game_fans(game_id)
