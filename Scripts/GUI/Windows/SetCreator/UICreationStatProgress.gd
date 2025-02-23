extends Node

class_name UICreationStatProgress

@export var progressBar: ProgressBar
@export var nameLabel: Label
@export var levelLabel: Label
@export var progressGained: Label

@export var updateSpeed: float = .5;

var goalValue: float
var statProgress: CreationStatLevel
var running: bool = false

func Init(_statProgress: CreationStatLevel, expGained: float):
	statProgress = _statProgress
	var currentExp: float = statProgress.experience
	var currenLevel = statProgress.level
	nameLabel.text = statProgress.creationStat.name
	levelLabel.text = str(currenLevel)
	progressBar.value = currentExp / statProgress.GetExpToLevelUp(currenLevel)
	progressGained.text = "+"+str(expGained)
	goalValue = (currentExp + expGained)  / statProgress.GetExpToLevelUp(currenLevel)
	
func Play():
	running = true;
	
func _process(delta):
	if (!running): return
	if (progressBar.value != goalValue):
		progressBar.value = lerp(progressBar.value, goalValue, updateSpeed * delta)
		if (progressBar.value == 1):
			levelLabel.text = str(statProgress.level)
			goalValue = statProgress.experience / statProgress.GetExpToLevelUp(statProgress.level)
			progressBar.value = 0
		
