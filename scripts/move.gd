extends PathFollow3D

func move(delta):
	progress += $Bus.speed * delta
	
func _physics_process(delta: float) -> void:
	move(delta)
