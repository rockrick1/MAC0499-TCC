extends "../base_shot.gd"


func _ready():
	$Projectile4.rotate(-.06)
	$Projectile4.direction = $Projectile4.direction.rotated(-.06)
	$Projectile5.rotate(.06)
	$Projectile5.direction = $Projectile5.direction.rotated(.06)
	for tween in $Tweens.get_children():
		var proj = get_node("Projectile"+tween.name)
		var offset = -12
		if "3" in tween.get_name() or "5" in tween.get_name():
			offset = 12
		if "4" in tween.get_name() or "5" in tween.get_name():
			offset *= 1.5
		tween.interpolate_property(proj, "position:x",
		proj.position.x,
		proj.position.x + offset,
		.1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
