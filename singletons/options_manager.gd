extends Node

func _ready() -> void:
	OS.window_position = OS.get_screen_size(OS.current_screen) / 2.0 - OS.window_size / 2.0
