extends Node

class_name Station

@export var station_name: String
@export var passenger_scene: PackedScene
var passengers: Array[Passenger]
var spawn_point: Vector3

func _init() -> void:
	print('Created another station')
	# TODO: make a random name
	
func _ready() -> void:
	# Regsiter station with GameManager
	GameManager.stations.append(self)
	
	# TODO: Maybe change this to use the station node position
	var collision_node: CollisionShape3D = self.get_node("Area3D/CollisionShape3D")
	var size = collision_node.shape.get_debug_mesh().get_aabb().size
	spawn_point = (Vector3(-1, 0, 1) * size / 2) + Vector3(0, 0, 2)
	
	# Set up area collision detection
	var area_node: Area3D = self.get_node("Area3D")
	area_node.area_entered.connect(_on_area_entered)

# TODO: you can use collision matrices instead to guarantee bus collision
#		- assume the only collisions that will be happening are bus x station
func _on_area_entered(area: Area3D) -> void:
	if area.name == "BusArea":
		# Drop off passengers first
		%Bus.unload_passengers(self)
		# Then load passengers
		if len(passengers):
			%Bus.load_passengers(passengers)
			for passenger in passengers:
				self.remove_child(passenger)
			passengers.clear()
		
func spawn_passengers():
	var num_passengers = randf_range(1, 1)
	var all_other_stations = GameManager.stations.filter(func(s): return s != self)
	for i in num_passengers:
		var new_passenger: Passenger = passenger_scene.instantiate()
		new_passenger.origin_station = self
		new_passenger.target_station = all_other_stations.pick_random()
		new_passenger.position = spawn_point + len(passengers) * Vector3(0, 0, 3)
		add_child(new_passenger)
		passengers.append(new_passenger)
