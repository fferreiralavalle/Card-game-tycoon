extends Node

class_name UIReview

@export var reviewer_name: Label
@export var reviewer_score: Label
@export var comentary: Label
@export var review_score_show_multiplier: float = 10

func init(expansion_review: SetReview) -> void:
	var reviewer = ReviewerManager.instance.get_reviewer(expansion_review.reviewer_id)
	if (reviewer):
		reviewer_name.text = reviewer.name;
	var score_text = str(floor(expansion_review.score * review_score_show_multiplier))
	reviewer_score.text = str(score_text) + "/" +str(review_score_show_multiplier)
