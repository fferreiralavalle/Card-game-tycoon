extends Resource

class_name ExpansionAddon

@export var id: String
@export var name: String
@export var category: String
@export var base_cost: float
@export var stat_bonus: SetCreationStats
@export var unlock_cost: float

var level: int = 0
var experience: float = 0

func get_level(): return level

func gain_experience(new_experience: float):
	print(name)
	experience += new_experience
	print("New Experience ", experience)
	var exp_to_next = get_exp_to_next_level()
	print("exp_to_next ", exp_to_next)
	while (exp_to_next <= 0):
		experience -= get_exp_to_level_up(level)
		level +=1
		exp_to_next = get_exp_to_next_level()
		print("Level up to ", level)
		print("Remaining Exp ", experience)
		print("Exp to next ", exp_to_next)

func get_exp_to_level_up(_level: int): return AddonConstants.BASE_LEVEL_UP_EXP + AddonConstants.EXP_GROWTH_PER_LEVEL * _level

func get_exp_to_next_level(): return get_exp_to_level_up(level) - experience

func get_stat_bonus() -> SetCreationStats:
	return get_stat_bonus_at_level(get_level())

func get_stat_bonus_at_level(level: int) -> SetCreationStats:
	var bonus: SetCreationStats = stat_bonus.duplicate(true)
	bonus.design = AddonConstants.STAT_INCREASE_PER_LEVEL * level + stat_bonus.design
	bonus.art = AddonConstants.STAT_INCREASE_PER_LEVEL * level + stat_bonus.art
	bonus.lore = AddonConstants.STAT_INCREASE_PER_LEVEL * level + stat_bonus.lore
	return bonus


func get_cost(_expansion: Set) -> float:
	return base_cost