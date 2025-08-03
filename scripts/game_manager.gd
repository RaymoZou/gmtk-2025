extends Node

const STARTING_MONEY : int = 100
const SPEED_COST : int = 50 # how much a speed increment costs

var stations: Array[Station] = []

var money: int = STARTING_MONEY
var satisfaction_rating: int

signal money_updated(amount : int)
signal satisfaction_updated(amount: int)
signal increase_bus_speed # increases bus speed

func _ready() -> void:
	money_updated.emit(money)
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	
func _on_passenger_dropped_off(fare: int, satisfaction: int) -> void:
	money += fare
	satisfaction_rating += satisfaction
	money_updated.emit(money)
	satisfaction_updated.emit(satisfaction_rating)
	print(money)
	
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
