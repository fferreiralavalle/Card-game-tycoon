extends PanelContainer

@export var compnayName: Label
@export var money: Label
@export var fans: Label
@export var min_money_speed = 1000
@export var min_fans_speed = 100

var company: Company

var target_money: float = 0
var current_money_shown: float = 0

var target_fans: int = 0
var current_fans_shown = 0

func _ready():
	GameManager.instance.created_company.connect(SetCompany)
	CompanyManager.instance.on_money_changed.connect(handle_income)
	CompanyManager.instance.on_fans_changed.connect(handle_fans)
	
func SetCompany(_company: Company):
	company = _company;
	update_info()

func handle_income(_income: IncomeInfo, newMoney: float):
	target_money = newMoney

func handle_fans(_fans_change: FansChange, new_fans: int):
	target_fans = new_fans

func update_info():
	compnayName.text = company.name
	update_money(company.money)
	target_money = company.money

func update_money(amount: float):
	money.text = "%.0f" % amount
	current_money_shown = amount

func update_fans(new_amount: int):
	fans.text = str(new_amount)
	current_fans_shown = new_amount

func _process(delta: float) -> void:
	if (!company): return
	if (target_money != current_money_shown):
		var speed = max(min_money_speed, abs(current_money_shown - target_money) * 10) * delta
		update_money(move_toward(current_money_shown, target_money, speed))
	if (target_fans != current_fans_shown):
		var speed = max(min_fans_speed, abs(current_fans_shown - target_fans) * 10) * delta
		update_fans(move_toward(current_fans_shown, target_fans, speed))
