class_name Company

var name: String
var money: float
var creationStats: CompanyCreationStats
var researchPoints: float;
var card_games: Array[CardGame] = []
var employees: Array[Employee] = []

func _init(_name: String, _money: float):
	name = _name;
	money = _money
	creationStats = CompanyCreationStats.new(
		CreationStatLevel.new(CreationStat.new("Design", "Design"),0,0),
		CreationStatLevel.new(CreationStat.new("Art", "Art"),0,0),
		CreationStatLevel.new(CreationStat.new("Lore", "Lore"),0,0),
	)

func add_card_game(card_game: CardGame):
	card_games.append(card_game)

func GetCreationStats(): return creationStats
