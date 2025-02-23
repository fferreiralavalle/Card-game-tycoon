extends Control

class_name UIMechanicCreator

@export var setCreationButton: Button;
@export var mechanic_creator: UIMechanicCreatorScreen

var mechanic: Mechanic

func _ready():
	setCreationButton.pressed.connect(open_creation_screen)
	mechanic_creator.on_finish.connect(handle_mechanic_complete)
	mechanic_creator.on_close.connect(handle_window_close)
	ActivityManager.instance.on_activity_finished.connect(check_for_mechanic_review_screen)

func handle_window_close():
	TimeManager.instance.isTimePassing = true
	mechanic_creator.visible = false
	mechanic_creator.set_process(false)

func open_creation_screen():
	TimeManager.instance.isTimePassing = false
	var power_level_min: float = MechanicConstants.BASE_POWER_LEVEL * (1 - MechanicConstants.POWER_LEVEL_VARIANCE)
	var power_level_max: float = MechanicConstants.BASE_POWER_LEVEL * (1 + MechanicConstants.POWER_LEVEL_VARIANCE)
	var power_level_value = randf_range(power_level_min, power_level_max)
	mechanic_creator.Init(
		Mechanic.new(
			"",
			power_level_value,
		),
		CompanyManager.instance.get_active_card_game().get_design_complexity()
	)
	mechanic_creator.visible = true
	mechanic_creator.set_process(true)

func handle_mechanic_complete(newMechanic: Mechanic):
	mechanic = newMechanic
	handle_window_close()

func open_mechanic_review_screen(newMechanic: Mechanic):
	print("Finished Mechanic ", newMechanic)
	return

func check_for_mechanic_review_screen(activity: Activity):
	if (activity is CreateMechanicActivity):
		open_mechanic_review_screen((activity as CreateMechanicActivity).mechanic)

func simulate_sales(success_score):
	return int(success_score * 100 + randf() * 5000)
