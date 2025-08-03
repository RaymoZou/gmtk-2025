extends Node3D

class_name Bus

const SPEED_INCREMENT : int = 2
var passengers: Array[Passenger]
var speed : int = 50

@onready var audio_stream_player_3d : AudioStreamPlayer3D = %AudioStreamPlayer3D

func _init() -> void:
	print("bus initialized")
	GameManager.increase_bus_speed.connect(_on_increase_bus_speed)
	
func _on_increase_bus_speed():
	speed += SPEED_INCREMENT
	SignalBus.speed_increased.emit(speed)

func load_passengers(new_passengers: Array[Passenger]) -> void:
	print_debug("Loading %s passengers at %s" % [len(new_passengers), new_passengers[0].origin_station])
	self.passengers.append_array(new_passengers)
	for p in new_passengers:
		p.board_bus()
	audio_stream_player_3d.play()

func unload_passengers(station: Station) -> void:
	var passengers_to_unload = passengers.filter(func(p): return p.target_station == station)
	print_debug("Unloading %s passengers at %s" % [len(passengers_to_unload), station])
	for i in range(passengers_to_unload.size() - 1, -1, -1):
		var passenger = passengers_to_unload[i]
		if passenger.target_station == station:
			passenger.leave_bus()
			passengers.remove_at(i)
