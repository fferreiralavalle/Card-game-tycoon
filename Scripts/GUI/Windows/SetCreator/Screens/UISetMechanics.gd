extends UISetCreationStep

class_name UISetMechanics

@export var mechanic_selector: UIMechanicSelector

func _ready():
	super._ready()

func Init(newSet: Set):
	super.Init(newSet)

func HandleDone():
	currentSet.general_mechanics = mechanic_selector.get_selected_mechanics()
	super.HandleDone()
