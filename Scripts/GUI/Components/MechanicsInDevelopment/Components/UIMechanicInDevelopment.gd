extends PanelContainer

class_name UIMechanicInDevelopment

@export var mechanic_name: Label
@export var progress_bar: ProgressBar

var activity: CreateMechanicActivity

func _ready() -> void:
	TimeManager.instance.on_weeks_passed.connect(func(_weeksPassed: int): UpdateValues())

func Init(activity: CreateMechanicActivity) -> void:
	self.activity = activity
	mechanic_name.text = activity.mechanic.name
	progress_bar.value = activity.get_progress()

func UpdateValues():
	progress_bar.value = activity.get_progress()
