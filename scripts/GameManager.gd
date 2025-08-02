extends Node

class_name GameManager

var money: int = 0
var satisfaction_rating: int = 0

func _on_passenger_left_bus(fare: int, satisfaction: int) -> void:
	var debug_str = "Passenger has left bus. Fare: %s Satisfaction: %s"
	print(debug_str % [fare, satisfaction])
	money += fare
	satisfaction_rating += satisfaction
