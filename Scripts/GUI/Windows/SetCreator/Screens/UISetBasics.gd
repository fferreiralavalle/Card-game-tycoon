extends UISetCreationStep

class_name UISetBasics

@export var name_input: LineEdit
@export var art_slider: HSlider
@export var design_slider: HSlider
@export var lore_slider: HSlider
@export var totalPointsLabel: Label

var art_points: int = 0
var balance_points: int = 0
var lore_points: int = 0

func _ready():
	super._ready()
	design_slider.value_changed.connect(func(_changed: float): HandleUpdatePoints())
	art_slider.value_changed.connect(func(_changed: float): HandleUpdatePoints())
	lore_slider.value_changed.connect(func(_changed: float): HandleUpdatePoints())

func Init(_currentSet: Set):
	super.Init(_currentSet)
	# assign max points for sliders
	var creationStats: CompanyCreationStats = CompanyManager.instance.company.GetCreationStats()
	design_slider.max_value = creationStats.GetDesignPointsMax()
	art_slider.max_value = creationStats.GetArtPointsMax()
	lore_slider.max_value = creationStats.GetLorePointsMax()
	

func GetTotalPoints() -> int:
	return art_points + balance_points + lore_points

func HandleUpdatePoints():
	art_points = int(art_slider.value)
	balance_points = int(design_slider.value)
	lore_points = int(lore_slider.value)
	totalPointsLabel.text = str(GetTotalPoints())

func HandleDone():
	var creationStats: SetCreationStats = SetCreationStats.new()
	creationStats.design = balance_points
	creationStats.art = art_points
	creationStats.lore = lore_points
	currentSet = Set.new(name_input.text, null, creationStats)
	super.HandleDone()
