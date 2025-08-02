extends PathFollow3D

# progresses children along the parent 3D path 

func move(delta):
	progress += 4 * delta
	return
	
func _physics_process(delta: float) -> void:
	move(delta)
