extends Node

class_name Station

@onready var passenger_spawn_timer: Timer = $PassengerSpawnTimer

@export var station_name: String
@export var passenger_scene: PackedScene
var passengers: Array[Passenger]
var spawn_point: Vector3

func _init() -> void:
	print('Created another station')
	# TODO: make a random name
	
func _ready() -> void:
	# TODO: Maybe change this to use the station node position
	var collision_node: CollisionShape3D = self.get_node("Area3D/CollisionShape3D")
	var size = collision_node.shape.get_debug_mesh().get_aabb().size
	spawn_point = (Vector3(-1, 0, 1) * size / 2) + Vector3(0, 0, 2)

func _on_passenger_spawn_timer_timeout() -> void:
	print("SPAWN PASSENGERS")
	var num_passengers = randi_range(1, 3)
	for i in num_passengers:
		var new_passenger = passenger_scene.instantiate()
		new_passenger.position = spawn_point + len(passengers) * Vector3(0, 0, 3)
		add_child(new_passenger)
		passengers.append(new_passenger)
