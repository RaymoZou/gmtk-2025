extends Area3D

class_name Station

@export var station_name: String
@export var passenger_scene: PackedScene
const INITIAL_CAPACITY: int = 6 # Initial number of passengers at the station
const CAPACITY_COST: int = 100 # Cost to increase capacity
const CAPACITY_INCREMENT: int = 1 # how much to increase capacity by
const SPAWN_TIME: float = 2.0 # Time between passenger spawns
var capacity: int
var passengers: Array[Passenger]
var spawn_point: Vector3
@onready var mesh : MeshInstance3D = $model/Cube
@onready var capacity_label : Label3D = %CapacityLabel
@export var highlight_mat : Resource

func _init() -> void:
	print('Created another station')
	
func _ready() -> void:
	# Register station with GameManager
	GameManager.stations.append(self)
	SignalBus.selected.connect(_on_selected)
	capacity = INITIAL_CAPACITY
	%Timer.autostart = true
	%Timer.wait_time = SPAWN_TIME
	%Timer.timeout.connect(spawn_passengers)
	%Timer.start()
	
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	area_entered.connect(_on_area_entered)

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mesh.material_overlay = highlight_mat
			SignalBus.selected.emit(self)

func _on_mouse_exited():
	capacity_label.visible = false

func _on_mouse_entered():
	capacity_label.text = "%d/%d" % [passengers.size(), capacity]
	capacity_label.visible = true

func increase_capacity():
	if GameManager.money >= CAPACITY_COST:
		capacity += CAPACITY_INCREMENT
		GameManager.money -= CAPACITY_COST
		SignalBus.station_updated.emit(self)
	else:
		print("Not enough money to increase capacity.")
	
# TODO: this is copy and paste from bus.gd - refactor into own scene
func _on_selected(object: Node):
	if object != self:
		mesh.material_overlay = null

# NOTE: assume only Bus collisions
# 1) unloads current passengers
# 2) loads new passengers based on available space of bus 
func _on_area_entered(bus: Area3D) -> void:
	bus.unload_passengers(self)
	var available_space : int = bus.capacity - bus.passengers.size()
	var passengers_to_load : int = min(available_space, passengers.size())
	var speed_buffer = bus.speed
	bus.speed = 0
	for i in passengers_to_load:
		var p : Passenger = passengers.pop_front()
		p.board_bus()
		remove_child(p)
		await bus.load_passenger(p)
	bus.speed = speed_buffer

# spawns a passenger at station with random target station that is NOT itself
# NOTE: there has to be at least 2 other stations in the main scene otherwise all_other_stations will be empty
func spawn_passengers():
	if passengers.size() >= capacity:
		# print_debug("Station %s is at full capacity." % station_name)
		return
	var num_passengers = randf_range(1, 1)
	var all_other_stations = GameManager.stations.filter(func(s): return s != self)
	for i in num_passengers:
		var new_passenger: Passenger = passenger_scene.instantiate()
		new_passenger.origin_station = self
		new_passenger.target_station = all_other_stations.pick_random()
		new_passenger.position = spawn_point + len(passengers) * Vector3(0, 0, 3)
		add_child(new_passenger)
		passengers.append(new_passenger)
