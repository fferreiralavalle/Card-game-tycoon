extends Resource

class_name Reviewer

@export var id: String;
@export var name: String
@export var initial_fans: int
@export var growth_per_week: int
@export var money_per_fan: float = 10
## multiplier for expected stats applied each week
@export var weekly_expected_stat_growth_multiplier: float = 0.05

var fans_pool: FansPool; 

@export var base_expected_creation_stats: SetCreationStats

func get_expected_creation_stats() -> SetCreationStats:
	var weeks_passed: int = TimeManager.instance.weeks_passed
	var multiplier: float = 1 + weekly_expected_stat_growth_multiplier * weeks_passed
	var creation_stats: SetCreationStats = base_expected_creation_stats.duplicate()
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
	return set_score_final

func get_game_fans(game_id: String) -> int:
	return fans_pool.get_game_fans(game_id)
