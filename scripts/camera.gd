extends Camera3D

const MAX_ZOOM_IN : int = 10
const MAX_ZOOM_OUT : int = 200
const ZOOM_AMOUNT : int = 10
const PAN : float = 40

func _process(delta : float) -> void:
	if Input.is_action_just_released("scroll_up") and size > MAX_ZOOM_IN:
		size -= ZOOM_AMOUNT
		
	if Input.is_action_just_released("scroll_down") and size <= MAX_ZOOM_OUT:
		size += ZOOM_AMOUNT
		
	if Input.is_action_pressed("ui_right"):
		h_offset += PAN * delta
		
	if Input.is_action_pressed("ui_left"):
		h_offset -= PAN * delta

	if Input.is_action_pressed("ui_up"):
		v_offset += PAN * delta

	if Input.is_action_pressed("ui_down"):
		v_offset -= PAN * delta
