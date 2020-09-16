extends Node2D


func set_vars(pos, shooter, dir):
	for proj in get_children():
		if "Projectile" in proj.get_name():
			proj.set_rotation(dir.angle())
			proj.set_vars(pos, shooter, dir, true)
			for child_proj in proj.get_children():
				if "Projectile" in child_proj.get_name():
					child_proj.set_vars(pos, shooter, dir, false)
