extends Node

const STARTING_MONEY : int = 100
const SATISFACTION_LEVEL_GOAL: int = 1500

var stations: Array[Station] = []

var money: int = STARTING_MONEY
var satisfaction_rating: int = 0
@export var selected: Node # currently selected item (bus, station, etc.)

signal money_updated(amount : int)
signal satisfaction_updated(amount: int)
signal game_over

func _ready() -> void:
	money_updated.emit(money)
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	SignalBus.speed_increased.connect(_on_speed_increased)

func _on_speed_increased(_bus: Bus) -> void:
	money_updated.emit(money)

func _on_passenger_dropped_off(fare: int, satisfaction: int) -> void:
	money += fare
	satisfaction_rating += satisfaction
	money_updated.emit(money)
	satisfaction_updated.emit(satisfaction_rating)
	
	if satisfaction_rating >= SATISFACTION_LEVEL_GOAL:
		game_over.emit()
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			SignalBus.selected.emit(null)