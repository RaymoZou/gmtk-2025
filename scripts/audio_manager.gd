extends AudioStreamPlayer

func _ready() -> void:
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	
func _on_passenger_dropped_off(_money: int, _satisfaction: int):
	# print("sfx: passenger dropped off")
	play()
