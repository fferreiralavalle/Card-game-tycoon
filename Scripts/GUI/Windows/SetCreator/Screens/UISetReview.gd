extends GameWindow

class_name UISetReview

@export var expContainer: Control
@export var expGainedPrefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UICreationStatProgress:
			push_error("Assigned scene must inherit from UICreationStatProgress!")
		else:
			expGainedPrefab = value

func _ready():
	super._ready()

func Init(newSet: Set):
	for node in expContainer.get_children():
		remove_child(node)
		node.queue_free()
	var creationProgress: CompanyCreationStats = CompanyManager.instance.company.GetCreationStats()
	# DESIGN
	var designProgress = expGainedPrefab.instantiate() as UICreationStatProgress
	var designExpGained = newSet.stats.design
	designProgress.Init(
		creationProgress.designLevel,
		designExpGained
		)
	designProgress.Play()
	creationProgress.designLevel.GainExp(designExpGained)
	# ART
	var artProgress = expGainedPrefab.instantiate() as UICreationStatProgress
	var artExpGained = newSet.stats.art
	artProgress.Init(
		creationProgress.artLevel,
		artExpGained
	)
	artProgress.Play()
	creationProgress.artLevel.GainExp(artExpGained)
	# LORE
	var loreProgress = expGainedPrefab.instantiate() as UICreationStatProgress
	var loreExpGained = newSet.stats.lore
	loreProgress.Init(
		creationProgress.loreLevel,
		loreExpGained
	)
	loreProgress.Play()
	creationProgress.loreLevel.GainExp(loreExpGained)
	# add instances
	expContainer.add_child(designProgress)
	expContainer.add_child(artProgress)
	expContainer.add_child(loreProgress)
