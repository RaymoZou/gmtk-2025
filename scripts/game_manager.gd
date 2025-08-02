extends Node

const STARTING_MONEY : int = 200
const SPEED_COST : int = 10 # how much a speed increment costs

var money: int = STARTING_MONEY
var satisfaction_rating: int

signal money_updated(amount : int)
signal increase_bus_speed # increases bus speed

func _ready() -> void:
	money_updated.emit(money)
	
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
