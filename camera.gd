# player camera controls - assumes Orthogonal projection
extends Camera3D

const ZOOM_AMOUNT = 10

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_down"):
		size -= ZOOM_AMOUNT
		
	if event.is_action_pressed("scroll_up"):
		size += ZOOM_AMOUNT
