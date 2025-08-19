extends Path3D

class_name Track

@export var bus_scene : PackedScene
@export var bus_path_scene : PackedScene
@onready var mesh : MeshInstance3D = $model/loop0/Loop1

func _ready() -> void:
	spawn_bus(100)

# 1) add child PathFollow3D
# 2) add bus scene as child of PathFollow3D
func spawn_bus(offset: float) -> void:
	var path = bus_path_scene.instantiate()
	add_child(path)
	path.progress = offset
	var bus_instance = bus_scene.instantiate()
	path.add_child(bus_instance)
