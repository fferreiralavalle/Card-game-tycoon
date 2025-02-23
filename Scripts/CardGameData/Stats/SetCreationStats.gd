extends Resource

class_name SetCreationStats

@export var design: float = 0
@export var art: float = 0
@export var lore: float = 0

func GetTotalPoints() -> float:
	return design + art + lore
