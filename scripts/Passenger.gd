extends Node

class_name Passenger

var satisfaction: int = 50
var origin_station: Station
var target_station: Station
var on_bus: bool = false
const FARE : int = 5
const PATIENCE_RATE: int = 1

@onready var satisfaction_label = %SatisfactionLabel

func board_bus() -> void:
	on_bus = true

func leave_bus() -> void:
	satisfaction += 10
	SignalBus.passenger_dropped_off.emit(FARE, satisfaction)
	queue_free()

func _on_satisfaction_tick_timer_timeout() -> void:
	if not on_bus:
		satisfaction = max(0, satisfaction - PATIENCE_RATE)
		satisfaction_label.text = "%s" % satisfaction
