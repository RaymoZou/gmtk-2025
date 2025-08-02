extends Node

class_name Passenger

var satisfaction: int
var target_station: Station

func _init(_target_station: Station) -> void:
	target_station = _target_station

func leave_bus() -> void:
	print("Passenger leaving bus")
	# TODO: based on individual satisifaction, alter the game state satisfaction
	# TODO: pay fare -> add money to game state
