extends Area3D

class_name Bus

const SPEED_INCREMENT : int = 2
var passengers: Array[Passenger]
var speed : int = 20
var capacity : int = 3

@onready var audio_stream_player_3d : AudioStreamPlayer3D = %AudioStreamPlayer3D
@export var highlight_mat : Resource
@onready var mesh : MeshInstance3D = $bus/Cube

func _init() -> void:
	print("bus initialized")
	if highlight_mat == null:
		print_debug("need a highlight material!")
	GameManager.increase_bus_speed.connect(_on_increase_bus_speed)
	SignalBus.selected.connect(_on_selected)
	input_event.connect(_on_input_event)
	
	# NOTE: not sure if there's a better way of doing this but i'm just trying to initialize 
	#		passengers to be size capacity but empty
	passengers.resize(capacity)
	passengers.clear()
	
func _on_selected(object : Node):
	if object != self:
		mesh.material_overlay = null
	
func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mesh.material_overlay = highlight_mat
			SignalBus.selected.emit(self)
			
	
func _on_increase_bus_speed():
	speed += SPEED_INCREMENT
	SignalBus.speed_increased.emit(speed)

# station.gd handles the passenger loading - just play sfx
func load_passenger(p : Passenger) -> void:
	audio_stream_player_3d.play()
	passengers.push_back(p)

func unload_passengers(station: Station) -> void:
	var passengers_to_unload = passengers.filter(func(p): return p.target_station == station)
	print_debug("Unloading %s passengers at %s" % [len(passengers_to_unload), station])
	for i in range(passengers_to_unload.size() - 1, -1, -1):
		var passenger = passengers_to_unload[i]
		if passenger.target_station == station:
			passenger.leave_bus()
			passengers.remove_at(i)
