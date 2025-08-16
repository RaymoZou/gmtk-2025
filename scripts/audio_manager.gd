extends AudioStreamPlayer

func _ready() -> void:
	# for now, play a sound effect whenever the bus state changes
	# might need specific signals to be emitted in the future
	SignalBus.bus_updated.connect(_on_bus_updated)

func _on_bus_updated(_bus: Bus):
	play()
