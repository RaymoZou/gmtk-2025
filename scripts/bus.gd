extends Area3D

class_name Bus

const SPEED_INCREMENT: int = 2 # how much to increase speed by
const CAPACITY_INCREMENT: int = 1 # how much to increase capacity by
const SPEED_COST : int = 50 # how much a speed increment costs
const CAPACITY_COST: int = 150 # how much a capacity increment costs
const LOADING_TIME_COST : int = 100 # how much a loading time increment costs
const LOADING_TIME_INCREMENT: float = 0.5 # how much to decrease loading time by
var loading_time: float = 2 # how long it takes to load a single passenger
var passengers: Array[Passenger]
var speed: int = 20
var capacity: int = 3

@onready var capacity_label : Label3D = %CapacityLabel
@onready var audio_stream_player_3d: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var mesh: MeshInstance3D = $bus/Cube
@onready var load_timer: Timer = %Timer
@export var highlight_mat: Resource

func _init() -> void:
	# print("bus initialized")
	if highlight_mat == null:
		print_debug("need a highlight material!")
	SignalBus.selected.connect(_on_selected)
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# NOTE: not sure if there's a better way of doing this but i'm just trying to initialize
	#		passengers to be size capacity but empty
	passengers.resize(capacity)
	passengers.clear()

func _ready() -> void:
	load_timer.wait_time = loading_time
	load_timer.start()
	load_timer.autostart = false

func _on_mouse_exited():
	capacity_label.visible = false

func _on_mouse_entered():
	capacity_label.text = "%d/%d" % [passengers.size(), capacity]
	capacity_label.visible = true

func _on_selected(object: Node):
	if object != self:
		mesh.material_overlay = null
	
func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mesh.material_overlay = highlight_mat
			SignalBus.selected.emit(self)


# 1) increases the speed of the bus
# 2) deducts money
# 3) tells alls listeners of money_updated that money has been updated - useful
#	 for ui updates
func increase_speed():
	if GameManager.money >= SPEED_COST:
		speed += SPEED_INCREMENT
		GameManager.money -= SPEED_COST
		SignalBus.bus_updated.emit(self)
	else:
		print("Not enough money to increase speed.")

# station.gd handles the passenger loading - just play sfx
func load_passenger(p: Passenger) -> void:
	await load_timer.timeout
	audio_stream_player_3d.play()
	passengers.push_back(p)

func unload_passengers(station: Station) -> void:
	var passengers_to_unload = passengers.filter(func(p): return p.target_station == station)
	# print_debug("Unloading %s passengers at %s" % [len(passengers_to_unload), station])
	for i in range(passengers_to_unload.size() - 1, -1, -1):
		var passenger = passengers_to_unload[i]
		if passenger.target_station == station:
			passenger.leave_bus()
			passengers.remove_at(i)

# BUS UPGRADES

func decrease_loading_time():
	if GameManager.money >= LOADING_TIME_COST:
		loading_time -= LOADING_TIME_INCREMENT
		GameManager.money -= LOADING_TIME_COST
		SignalBus.bus_updated.emit(self)
	else:
		print("Not enough money to decrease loading time.")

func increase_capacity():
	if GameManager.money >= CAPACITY_COST:
		capacity += CAPACITY_INCREMENT
		GameManager.money -= CAPACITY_COST
		SignalBus.bus_updated.emit(self)
	else:
		print("Not enough money to increase capacity.")
