extends Control

class_name GameWindow

@export var close_button: BaseButton

signal on_close()

func _ready() -> void:
	close_button.pressed.connect(handle_close)
	
func handle_close():
	on_close.emit()
