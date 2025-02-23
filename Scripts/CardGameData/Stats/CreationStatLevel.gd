
class_name CreationStatLevel

var creationStat: CreationStat
var level: int;
var experience: float

func _init(_creationStat: CreationStat, _level: int, _exp: float):
	creationStat = _creationStat
	level = _level
	experience = _exp

func GetExpToLevelUp(_level: int): return 50 + 50 * _level

func GetExpToNextLevel(): return GetExpToLevelUp(level) - experience

func GainExp(gainedExp: float):
	print(creationStat.id)
	experience += gainedExp
	print("New Experience ", experience)
	var expToNext = GetExpToNextLevel()
	print("expToNext ", expToNext)
	while (expToNext <= 0):
		experience -= GetExpToLevelUp(level)
		level +=1
		expToNext = GetExpToNextLevel()
		print("Level up to ", level)
		print("Remaining Exp ", experience)
		print("Exp to next ", expToNext)
