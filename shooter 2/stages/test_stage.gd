extends "base_stage.gd"




func _ready():
	MainNodes.set_stats($CanvasLayer/Stats)


func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$EnemyGenerator.start_next_wave()
