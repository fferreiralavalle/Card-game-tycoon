extends GameWindow

class_name UIExpansionReception

@export var review_container: Control
@export var expansion_review_prefab: PackedScene:
	set(value):
		if value and not value.instantiate() is UIReview:
			push_error("Assigned scene must inherit from UIReview!")
		else:
			expansion_review_prefab = value

func init(expansion_reception: SetReception) -> void:
	for node in review_container.get_children():
		node.free()
	for review in expansion_reception.reviews:
		var review_ui = expansion_review_prefab.instantiate() as UIReview
		review_ui.init(review)
		review_container.add_child(review_ui)
