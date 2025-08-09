extends Node

const STARTING_MONEY : int = 100
const SPEED_COST : int = 50 # how much a speed increment costs
const SATISFACTION_LEVEL_GOAL: int = 1500

var stations: Array[Station] = []

var money: int = STARTING_MONEY
var satisfaction_rating: int = 0
@export var selected: Node # currently selected item (bus, station, etc.)

signal money_updated(amount : int)
signal satisfaction_updated(amount: int)
signal game_over
signal increase_bus_speed # increases bus speed

func _ready() -> void:
	money_updated.emit(money)
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	
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
	
# 1) increases the speed of the bus
# 2) deducts money
# 3) tells alls listeners of money_updated that money has been updated - useful
#	 for ui updates
func increase_speed():
	if (money >= SPEED_COST):
		increase_bus_speed.emit()
		money -= SPEED_COST
		money_updated.emit(money)
	else:
		print("no money :(")
