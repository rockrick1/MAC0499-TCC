extends "base_stage.gd"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$EnemyGenerator.start_next_wave()
		return
#		var params = DBManager.get_vars("generators/spinning6")
#		print(params.fire_rate)
#		$Enemies/Enemy1/BulletGenerator.set_params(params)
#		$Enemies/Enemy1/BulletGenerator.start()
#		params.base_spin_speed = -80
#		params.fire_rate = 20
#		print(params.fire_rate)
#		$Enemies/Enemy1/BulletGenerator2.set_params(params)
#		$Enemies/Enemy1/BulletGenerator2.modulate_bullets(Color(.1,.35,1,1))
#		$Enemies/Enemy1/BulletGenerator2.start()
