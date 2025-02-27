extends Node

class_name UIMechanicsInDevelopmentList

@export var active_mechanic_container: Control
@export var mechanic_in_development_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIMechanicInDevelopment:
			push_error("Assigned scene must inherit from UIMechanicInDevelopment!")
		else:
			mechanic_in_development_prefab = value

func _ready() -> void:
	ActivityManager.instance.on_activity_started.connect(check_for_new_mechanic)
	LoadSets()

func LoadSets():
	for node in active_mechanic_container.get_children():
		remove_child(node)
		node.queue_free()
	for activity_set in ActivityManager.instance.get_activities_by_id(CreateMechanicActivity.id):
		add_new_set(activity_set as CreateMechanicActivity)

func check_for_new_mechanic(new_activity: Activity):
	if (new_activity.get_activity_id() == CreateMechanicActivity.id):
		add_new_set(new_activity as CreateMechanicActivity)

func add_new_set(new_activity: CreateMechanicActivity):
		var active_mechanic_activity = new_activity as CreateMechanicActivity
		var active_mechanic_ui = mechanic_in_development_prefab.instantiate() as UIMechanicInDevelopment
		active_mechanic_ui.Init(active_mechanic_activity)
		active_mechanic_container.add_child(active_mechanic_ui)
		new_activity.on_activity_finished.connect(func(): remove_finished_activity(new_activity.mechanic))

func remove_finished_activity(finished_mechanic: Mechanic):
	for node in active_mechanic_container.get_children():
		var activity_set_mechanic = node as UIMechanicInDevelopment
		if (activity_set_mechanic.activity.mechanic == finished_mechanic):
			node.queue_free()
			break;
