extends PathFollow3D

# NOTE: we're only able to use % here because it assumes we only have one bus
func move(delta):
	progress += %Bus.speed * delta
	
func _physics_process(delta: float) -> void:
	move(delta)
