extends Node3D

class_name Bus

const SPEED_INCREMENT : int = 2
var passengers: Array[Passenger]
var speed : int = 8

func _init() -> void:
	print("bus initialized")
	GameManager.increase_bus_speed.connect(_on_increase_bus_speed)
	
func _on_increase_bus_speed():
	speed += SPEED_INCREMENT
	SignalBus.speed_increased.emit(speed)

func load_passengers() -> void:
	print('Load passengers')
	# TODO
	# 1. Check if bus is in "loading" state
	# 2. Load a random number of passengers
	#    - Number of passengers should be determined by factors such as satisfaction rating, etc.
	# 3. Emit signal that passengers have been loaded

func unload_passengers(station: Station) -> void:
	print('Unload passengers')
	# Iterate backward to not affect indices
	for i in range(passengers.size() - 1, -1, -1):
		var passenger = passengers[i]
		if station == passenger.target_station:
			passenger.leave_bus()
			passengers.remove_at(i)

	# NOTE: Maybe need to emit a signal here that passengers are unloaded
