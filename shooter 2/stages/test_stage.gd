extends "base_stage.gd"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$EnemyGenerator.start_next_wave()
