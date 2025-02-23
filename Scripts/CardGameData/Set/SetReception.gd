class_name SetReception

var reviews: Array[SetReview] = []

func get_average_score() -> float:
	var score_sum = 0
	for review in reviews:
		score_sum += review.score
	return score_sum / reviews.size()
