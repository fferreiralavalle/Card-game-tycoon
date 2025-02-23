extends Node

class_name CompanyManager 

static var instance: CompanyManager

@export var progressPerWeek: float = 5
@export var progressPerEmployeeStatLevel: float = 1

var company: Company
var current_card_game: CardGame

signal on_expansion_income(income: float, expansion: Set)
signal on_money_changed(change: IncomeInfo, newAmount: float)
signal on_fans_changed(change: FansChange, new_amount: int)

func DevelopSet(newSet: Set):
	ActivityManager.instance.start_activity(CreateSetActivity.new(
		newSet,
		newSet.employees
	))

func _init():
	instance = self;

func _ready() -> void:
	TimeManager.instance.on_weeks_passed.connect(handle_weeks_passed)
	TimeManager.instance.on_months_passed.connect(handle_months_passed)
	GameManager.instance.created_company.connect(set_company)

func set_company(_company: Company):
	company = _company
	company.employees.append(Employee.new("Design", "Nerd",
		CompanyCreationStats.new(
				CreationStatLevel.new(CreationStat.new("Design", "Design"),5,0),
				CreationStatLevel.new(CreationStat.new("Art", "Art"),0,0),
				CreationStatLevel.new(CreationStat.new("Lore", "Lore"),0,0),
		)
	))
	company.employees.append(Employee.new("Art", "Nerd",
		CompanyCreationStats.new(
				CreationStatLevel.new(CreationStat.new("Design", "Design"),0,0),
				CreationStatLevel.new(CreationStat.new("Art", "Art"),4,0),
				CreationStatLevel.new(CreationStat.new("Lore", "Lore"),0,0),
		)
	))
	var card_game = CardGame.new("New Card Game", "player_card_game_0")
	card_game.mechanics.append(Mechanic.new("Charge", 50))
	card_game.mechanics.append(Mechanic.new("Taunt", 50))
	card_game.mechanics.append(Mechanic.new("Spell Damage", 50))
	card_game.mechanics.append(Mechanic.new("Grow", 50))
	card_game.mechanics.append(Mechanic.new("Burn", 50))
	company.add_card_game(
		card_game
	)
	set_active_card_game(company.card_games[0])

func set_active_card_game(card_game: CardGame):
	current_card_game = card_game

func get_active_card_game(): return current_card_game

func get_company(): return company

func handle_weeks_passed(_weeksPassed: int):
	handle_sets_weekly_income() # TODO: add many weeks passed
	handle_sets_weekly_fans()
	return

func handle_months_passed(months_passed: int):
	var employees = company.employees
	# handle employees salary payment
	for employee in employees:
		gain_income(
			IncomeInfo.new(
				-employee.salary * months_passed,
				"Employee Salaries"
			)
		)

func get_available_employees() -> Array[Employee]:
	var available_employees: Array[Employee] = []
	var busy_employees = ActivityManager.instance.get_busy_employees()
	for employee in company.employees:
		if (!busy_employees.has(employee)):
			available_employees.append(employee)
			
	return available_employees

func gain_income(incomeInfo: IncomeInfo) -> float:
	company.money += incomeInfo.amount
	on_money_changed.emit(incomeInfo, company.money)
	return company.money
	
func handle_sets_weekly_income() -> void:
	var income: float = 0
	for card_game in company.card_games:
		for expansion in card_game.sets:
			var exp_income = get_expansion_week_income(expansion)
			income += exp_income
			if (exp_income != 0): on_expansion_income.emit(exp_income, expansion)

	gain_income(IncomeInfo.new(income, "Expansions Sales"))

func handle_sets_weekly_fans() -> void:
	var fans_change: int = 0
	for card_game in company.card_games:
		for expansion in card_game.sets:
			var exp_income = get_expansion_weekly_fans(expansion)
			fans_change += exp_income
		on_fans_changed.emit(FansChange.new(fans_change, "Fans Growth"), card_game.get_fans())


func get_expansion_week_income(expansion: Set) -> float:
	var expansion_age = TimeManager.instance.get_age(expansion.birthday)
	var expansion_score = expansion.get_average_review_score()
	var life_expectancy = expansion.get_life_expectancy()
	var expectancy_left = clampf(life_expectancy - expansion_age, 0, life_expectancy)
	var fans_buy_power = get_active_card_game().get_fans_buy_power()
	
	var income_multiplier: float = pow(expectancy_left / life_expectancy, ExpansionConstants.EXPANSION_INCOME_FALLOFF_POW_WEEKLY)
	var base_income = fans_buy_power + ExpansionConstants.BASE_EXPANSION_EARNINGS
	var income_min = base_income * (1 - ExpansionConstants.EXPANSION_INCOME_VARIANCE)
	var income_max = base_income * (1 + ExpansionConstants.EXPANSION_INCOME_VARIANCE)
	var income = randf_range(income_min, income_max) * income_multiplier
	return income

func get_expansion_weekly_fans(expansion: Set) -> int:
	var card_game = get_active_card_game()
	var expansion_age = TimeManager.instance.get_age(expansion.birthday)
	var expansion_score = expansion.get_average_review_score()
	var life_expectancy = expansion.get_life_expectancy()
	var expectancy_left = clampf(life_expectancy - expansion_age, 0, life_expectancy)
	var total_fans_change: int = 0
	for reviewer_result in expansion.reception.reviews:
		var fans_change_life_expectancy_multiplier: float = pow(expectancy_left / life_expectancy, ExpansionConstants.EXPANSION_FANS_FALLOFF_POW_WEEKLY)
		
		var fans_min_variance_multiplier = (1 - ReviewerConstants.FANS_CHANGE_VARIANCE)
		var fans_max_variance_multiplier = (1 + ReviewerConstants.FANS_CHANGE_VARIANCE)
		var fans_change_multiplier = randf_range(fans_min_variance_multiplier, fans_max_variance_multiplier) * fans_change_life_expectancy_multiplier
		
		var reviewer: Reviewer = ReviewerManager.instance.get_reviewer(reviewer_result.reviewer_id)
		if (reviewer):
			var score = reviewer_result.score
			var score_change = score - ReviewerConstants.LOSE_FANS_SCORE_TRESHOLD
			if (score_change >= 0):
				var score_fans_gain_multiplier = pow(score_change, ReviewerConstants.GAIN_FANS_SCORE_POW) * fans_change_multiplier
				var fans_gain = reviewer.fans_pool.new_fans * score_fans_gain_multiplier
				total_fans_change += reviewer.fans_pool.add_game_fans(
					card_game.id,
					fans_gain
				)
			else:
				var score_fans_gain_multiplier = pow(-score_change, ReviewerConstants.LOSE_FANS_SCORE_POW) * -fans_change_multiplier
				var fans_lost = reviewer.fans_pool.get_game_fans(card_game.id) * score_fans_gain_multiplier
				total_fans_change += reviewer.fans_pool.add_game_fans(
					card_game.id,
					fans_lost
				)

	return total_fans_change
