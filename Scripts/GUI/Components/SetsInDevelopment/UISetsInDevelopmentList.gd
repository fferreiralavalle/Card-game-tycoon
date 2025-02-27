extends Node

class_name UISetsInDevelopmentList

@export var activeSetContainer: Control
@export var setInDevelopmentPrefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UISetInDevelopment:
			push_error("Assigned scene must inherit from UISetInDevelopment!")
		else:
			setInDevelopmentPrefab = value

func _ready() -> void:
	ActivityManager.instance.on_activity_started.connect(check_for_new_set)
	LoadSets()

func LoadSets():
	for activity_set in ActivityManager.instance.get_activities_by_id(CreateSetActivity.id):
		add_new_set(activity_set as CreateSetActivity)

func check_for_new_set(new_activity: Activity):
	if (new_activity.get_activity_id() == CreateSetActivity.id):
		add_new_set(new_activity as CreateSetActivity)

func add_new_set(newActivity: CreateSetActivity):
	var activeSetActivity = newActivity as CreateSetActivity
	var activeSetUI = setInDevelopmentPrefab.instantiate() as UISetInDevelopment
	activeSetUI.Init(activeSetActivity)
	activeSetContainer.add_child(activeSetUI)
	newActivity.on_set_finished.connect(remove_new_set)

func remove_new_set(finished_set: Set):
	for node in activeSetContainer.get_children():
		var activeSetUI = node as UISetInDevelopment
		if (activeSetUI.activity.active_set == finished_set):
			node.queue_free()
			break;
