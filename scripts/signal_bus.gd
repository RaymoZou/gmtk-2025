extends Node

# the state of a bus has changed
signal bus_updated(bus : Bus)

signal station_capacity_increased(station : Station)
signal passenger_dropped_off(money: int, satisfaction: int)
signal selected(object: Node)
