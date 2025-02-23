extends PanelContainer

@export var textEdit: LineEdit
@export var doneButton: Button

func _ready():
	doneButton.pressed.connect(OnSubmit)
	
func OnSubmit():
	GameManager.instance.CreateCompany(textEdit.text, 5000)
	queue_free()
