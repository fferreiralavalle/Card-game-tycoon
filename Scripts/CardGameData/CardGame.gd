class_name CardGame

var name: String
var id: String
var sets: Array[Set]
var mechanics: Array[Mechanic] = []

func _init(_name: String, id: String):
	name = _name
	self.id = id
	sets = []

func get_design_complexity() -> float:
	var mechanics_complexity = mechanics.size() * CardGameConstants.COMPLEXITY_PER_MECHANIC
	var sets_complexity = sets.size() * CardGameConstants.COMPLEXITY_PER_SET
	return CardGameConstants.BASE_COMPLEXITY + mechanics_complexity + sets_complexity

func get_fans() -> int:
	var fans: int = 0
	for reviewer in ReviewerManager.instance.reviewers:
		fans += reviewer.get_game_fans(id)
	return fans

func get_fans_buy_power() -> float:
	var total_buy_power: float = 0
	for reviewer in ReviewerManager.instance.reviewers:
		var fans_amount = reviewer.get_game_fans(id)
		var buy_amount = reviewer.money_per_fan
		total_buy_power += buy_amount * fans_amount
	return total_buy_power
	
