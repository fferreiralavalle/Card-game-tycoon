class_name GameFansPool

var company_id: String
var fans: int = 0

func _init(company_id: String, fans: int) -> void:
	self.company_id = company_id
	self.fans = fans
