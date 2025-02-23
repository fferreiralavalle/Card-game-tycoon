extends Node

class_name WindowManager

static var instance: WindowManager

@export var window_container: Control

var window_queue: Array[GameWindow] = []

func _init():
	instance = self;
	
func has_active_windows() -> bool:
	var child_count = window_container.get_child_count()
	return child_count != 0
	
func add_window(new_window: GameWindow):
	if (window_container.get_child_count() > 0):
		new_window.hide()
		window_queue.append(new_window)
	else:
		_open_window(new_window)

func handle_next_window():
	if (window_queue.size() > 0):
		var new_window = window_queue[0]
		_open_window(new_window)
		window_queue.erase(new_window)
	
func _open_window(new_window: GameWindow):
	window_container.add_child(new_window)
	new_window.show()
	new_window.on_close.connect(handle_next_window)
