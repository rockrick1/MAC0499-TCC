extends Node2D


func set_vars(pos, shooter, dir):
	for node in get_children():
		if "Projectile" in node.get_name():
			node.set_rotation(dir.angle())
			node.set_vars(pos, shooter, dir, true)
