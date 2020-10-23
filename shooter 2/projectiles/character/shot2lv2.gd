extends "../base_shot.gd"


func _ready():
	$Projectile2.position.y += 5
	$Projectile3.position.y += 5
	for tween in $Tweens.get_children():
		if tween:
			print(tween.name)
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


func _on_1_tween_completed(object, key):
	print("cabei!!!")
	pass # Replace with function body.
