extends Control

@export var setCreationButton: Button;
@export var setBasics: UISetCreationStep
@export var setEmployees: UISetCreationStep
@export var set_mechanics: UISetCreationStep

@export var set_review_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UISetReview:
			push_error("Assigned scene must inherit from UISetReview!")
		else:
			set_review_prefab = value

var newSet: Set

func _ready():
	setCreationButton.pressed.connect(OpenCreateScreen)
	setBasics.onNextStep.connect(HandleBasicsComplete)
	setEmployees.onNextStep.connect(handle_employee_step_complete)
	set_mechanics.onNextStep.connect(handle_mechanics_step_complete)
	ActivityManager.instance.on_activity_finished.connect(check_for_set_summary_screen)

func HandleWindowClose():
	TimeManager.instance.isTimePassing = true

func OpenCreateScreen():
	TimeManager.instance.isTimePassing = false
	setBasics.Init(newSet)
	setBasics.visible = true
	setBasics.set_process(true)

func HandleBasicsComplete(_newSet: Set):
	newSet = _newSet
	setBasics.visible = false
	# open next screen
	setEmployees.Init(newSet)
	setEmployees.visible = true
	setEmployees.set_process(true)

func handle_employee_step_complete(_newSet: Set):
	newSet = _newSet
	setEmployees.visible = false
	setEmployees.set_process(false)
	if (CompanyManager.instance.current_card_game.mechanics.size() > 0):
		set_mechanics.Init(newSet)
		set_mechanics.visible = true
		set_mechanics.set_process(true)
	else:
		finish_set(newSet)
		HandleWindowClose()


func handle_mechanics_step_complete(_newSet: Set):
	newSet = _newSet
	set_mechanics.visible = false
	set_mechanics.set_process(false)
	finish_set(newSet)
	HandleWindowClose()

func finish_set(new_set):
	new_set.add_bonus_stats()
	CompanyManager.instance.DevelopSet(newSet)

func check_for_set_summary_screen(activity: Activity):
	if (activity is CreateSetActivity):
		open_set_summary_screen((activity as CreateSetActivity).active_set)

func open_set_summary_screen(finished_set: Set):
	var expansion_review_ui = set_review_prefab.instantiate() as UISetReview
	expansion_review_ui.Init(finished_set)
	expansion_review_ui.on_close.connect(func(): expansion_review_ui.call_deferred("queue_free"))
	WindowManager.instance.add_window(expansion_review_ui)
