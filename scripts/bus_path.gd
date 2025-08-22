extends PathFollow3D

class_name BusPath

# NOTE: starting position of child Bus node - try to offset
@export var starting_position : float

func _ready() -> void:
	progress = starting_position

# NOTE: assume a child Bus node
func move(delta):
	progress += $Bus.speed * delta

func _physics_process(delta: float) -> void:
	move(delta)
