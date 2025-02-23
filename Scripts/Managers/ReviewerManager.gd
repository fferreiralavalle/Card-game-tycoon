extends Node

class_name ReviewerManager

@export var reviewers_folder = "res://Resources/Reviewers"
@export var reception_window_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIExpansionReception:
			push_error("Assigned scene must inherit from UIExpansionReception!")
		else:
			reception_window_prefab = value

var reviewers: Array[Reviewer] = []

static var instance: ReviewerManager

func _ready() -> void:
	ActivityManager.instance.on_activity_finished.connect(check_for_expansion_finished)

func _init():
	instance = self;
	reviewers = load_all_reviewers_from_folder(reviewers_folder)
	for reviewer in reviewers:
		print("Loaded Reviewer: ", reviewer.name, " with fan pool of ", reviewer.fans_pool.new_fans)

func load_all_reviewers_from_folder(folder_path: String) -> Array[Reviewer]:
	var reviewer_list: Array[Reviewer] = []
	var dir = DirAccess.open(folder_path)
	if dir == null:
		print("❌ Could not open directory: ", folder_path)
		return []

	if dir.list_dir_begin() != OK:
		print("❌ Could not list directory: ", folder_path)
		return []

	if dir and dir.list_dir_begin() == OK:
		var file_name = dir.get_next()
		while file_name != "":
			var file_path = folder_path + "/" + file_name
			
			if dir.current_is_dir():
				# Recursively load from subfolder
				reviewer_list.append_array(load_all_reviewers_from_folder(file_path))
			elif file_name.ends_with(".tres") or file_name.ends_with(".res"):  # Only load resources
				var resource = load(file_path)
				
				# Check if it's a valid CardData resource before adding
				if resource is Reviewer:
					var reviewer: Reviewer = (resource as Reviewer).duplicate(true)
					reviewer.fans_pool = FansPool.new(reviewer.initial_fans)
					reviewer_list.append(reviewer)
			
			file_name = dir.get_next()

	return reviewer_list

func check_for_expansion_finished(activity: Activity):
	if (activity is CreateSetActivity):
		var expansion = (activity as CreateSetActivity).active_set
		var reviews: Array[SetReview] = get_reviews(expansion)
		expansion.reception.reviews = reviews

		var expansion_reception_ui = reception_window_prefab.instantiate() as UIExpansionReception
		expansion_reception_ui.init(expansion.reception)
		expansion_reception_ui.on_close.connect(func(): expansion_reception_ui.call_deferred("queue_free"))
		WindowManager.instance.add_window(expansion_reception_ui)

func get_reviews(expansion: Set) -> Array[SetReview]:
	var reviews: Array[SetReview] = []
	for reviewer in reviewers:
		var score = reviewer.get_set_score(expansion)
		var expansion_review = SetReview.new(reviewer.id, score)
		reviews.append(expansion_review)
		print("Review for expansion: ",expansion.name, " from reviewer: ", reviewer.name, " - ", score)
	return reviews

func get_reviewer(reviewer_id: String) -> Reviewer:
	return reviewers.filter(func(reviewer): return reviewer.id == reviewer_id)[0]
