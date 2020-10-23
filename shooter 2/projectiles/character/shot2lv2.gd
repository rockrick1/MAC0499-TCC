extends "../base_shot.gd"


func _ready():
	$Projectile2.position.y += 5
	$Projectile3.position.y += 5
	for tween in $Tweens.get_children():
		var offset = -12
		var proj = $Projectile2
		if "2" in tween.get_name():
			proj = $Projectile3
			offset = 12
		tween.interpolate_property(proj, "position:x",
		proj.position.x,
		proj.position.x + offset,
		.1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
