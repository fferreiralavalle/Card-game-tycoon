class_name FansPool

var new_fans: int = 0

var game_fans: Array[GameFansPool] = []

func _init(new_fans: int) -> void:
	self.new_fans = new_fans
	game_fans = []

func add_new_fans(amount: int):
	new_fans += amount

## @return amount of fans either gained or lost by company
func add_game_fans(game_id: String, amount: int) -> int:
	var gain_amount = min(amount, new_fans)
	var game_fan_pool = _get_game_fans_pool(game_id)
	if (gain_amount > 0):
		# if the fan pool for that company doesn't exist, create it
		if (game_fan_pool == null):
			game_fan_pool = GameFansPool.new(game_id, gain_amount)
			game_fans.append(game_fan_pool)
		else:
			game_fan_pool.fans += gain_amount
		# substract fans taken from the available pool
		new_fans -= gain_amount
		return gain_amount
	else:
		if (game_fan_pool != null):
			# can't lose more fans than what you have
			var lose_amount = max(game_fan_pool.fans * -1, gain_amount)
			game_fan_pool.fans += lose_amount
			# return fans to the available pool
			new_fans -= lose_amount
			return lose_amount
		return 0

func _get_game_fans_pool(game_id: String) -> GameFansPool:
	for game_fan in game_fans:
		if (game_fan.company_id == game_id):
			return game_fan
	return null

func get_game_fans(game_id: String) -> int:
	for game_fan in game_fans:
		if (game_fan.company_id == game_id):
			return game_fan.fans
	return 0
