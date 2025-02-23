extends Node

class_name UISetCreationStep

@export var nextButton: Button

var currentSet: Set = null

signal onNextStep(set: Set)

func _ready():
	nextButton.pressed.connect(HandleDone)

func HandleDone():
	onNextStep.emit(currentSet)

func Init(_currentSet: Set):
	currentSet = _currentSet
