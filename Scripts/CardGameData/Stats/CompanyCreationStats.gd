class_name CompanyCreationStats

var designLevel: CreationStatLevel
var artLevel: CreationStatLevel
var loreLevel: CreationStatLevel

func _init(_designLevel: CreationStatLevel, _artLevel: CreationStatLevel, _loreLevel: CreationStatLevel):
	designLevel = _designLevel
	artLevel = _artLevel
	loreLevel = _loreLevel

func GetPointMax(level: int): return 50 + 25 * level

func GetDesignPointsMax():
	return GetPointMax(designLevel.level)

func GetArtPointsMax():
	return GetPointMax(artLevel.level)

func GetLorePointsMax():
	return GetPointMax(loreLevel.level)
