extends Node3D

# TODO: make the bus follow a predetermined route

var passenger_count: int

func _init() -> void:
	print("i am a bus")
	
# TODO:
func move():
	return
	
func _process(delta: float) -> void:
	move()

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
