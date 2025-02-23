class_name Employee

var name: String
var lastName: String
var creationStats: CompanyCreationStats
var stress: float
var salary: float

func _init(_name: String, _lastName: String, _creationStats: CompanyCreationStats = null):
	name = _name;
	lastName = _lastName
	if (_creationStats):
		creationStats = _creationStats
	else:
		creationStats = CompanyCreationStats.new(
			CreationStatLevel.new(CreationStat.new("Design", "Design"),0,0),
			CreationStatLevel.new(CreationStat.new("Art", "Art"),0,0),
			CreationStatLevel.new(CreationStat.new("Lore", "Lore"),0,0),
		)
	salary = calculate_average_salary()


func calculate_average_salary() -> float:
	var design_salary = creationStats.designLevel.level * EmployeeConstants.AVERAGE_SALARY_PER_DESIGN_LEVEL
	var art_salary = creationStats.artLevel.level * EmployeeConstants.AVERAGE_SALARY_PER_ART_LEVEL
	var lore_salary = creationStats.loreLevel.level * EmployeeConstants.AVERAGE_SALARY_PER_LORE_LEVEL
	return design_salary + art_salary + lore_salary


func GetCreationStats(): return creationStats

func AddStress(stressGain: float):
	stress = clamp(stress + stressGain, 0, 100)

func GainGeneralExp(expGained: float):
	creationStats.designLevel.GainExp(expGained)
	creationStats.artLevel.GainExp(expGained)
	creationStats.loreLevel.GainExp(expGained)
