extends Node

class_name Passenger

var satisfaction: int = 0
var origin_station: Station
var target_station: Station
const FARE : int = 5
@onready var area3d : Area3D = %Area3D

signal left_bus(fare: int, satisfaction: int)

# TODO: create a station that spawns passengers - they are not meant to
#     	instatiated directly
#func _init(_target_station: Station) -> void:
	#target_station = _target_station
	
func _ready() -> void:
	area3d.area_entered.connect(_on_area_entered)
	
func _on_area_entered(area3d : Area3D):
	SignalBus.passenger_picked_up.emit(self)

func leave_bus() -> void:
	print("Passenger leaving bus")
	left_bus.emit(3, satisfaction)
	# TODO: based on individual satisifaction, alter the game state satisfaction

	# TODO: pay fare -> add money to game state
