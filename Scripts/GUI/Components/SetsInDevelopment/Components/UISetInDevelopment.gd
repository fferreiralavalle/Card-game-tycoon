extends PanelContainer

class_name UISetInDevelopment

@export var setNameLabel: Label
@export var progressBar: ProgressBar

var activity: CreateSetActivity

func _ready() -> void:
	TimeManager.instance.on_weeks_passed.connect(func(_weeksPassed: int): UpdateValues())

func Init(activity_set: CreateSetActivity) -> void:
	activity = activity_set
	setNameLabel.text = activity_set.active_set.name
	progressBar.value = activity_set.get_progress()

func UpdateValues():
	progressBar.value = activity.get_progress()
