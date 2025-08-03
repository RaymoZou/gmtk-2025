extends Node

class_name Passenger

var satisfaction: int = 0
var origin_station: Station
var target_station: Station
const FARE : int = 5

func board_bus() -> void:
	origin_station.passengers.erase(self.get_instance_id())
	remove_child(self)
	self.visible = false

func leave_bus() -> void:
	SignalBus.passenger_dropped_off.emit(FARE, satisfaction)
	queue_free()
