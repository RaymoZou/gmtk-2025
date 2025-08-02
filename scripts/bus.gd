extends Node3D

class_name Bus

const SPEED_INCREMENT : int = 2
var passenger_count: int
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
	
func unload_passengers() -> void:
	print('Unload passengers')
	# TODO
	# 1. Check if bus is in "unloading" state (same as "loading"?)
	# 2. Check which passengers are getting off at this stop
	# 3. Invoke Passenger.leave_bus() for each passenger
	# 4. Emit signal that passengers have been unloaded
