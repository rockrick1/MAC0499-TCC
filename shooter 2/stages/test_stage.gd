extends "base_stage.gd"




func _ready():
	MainNodes.set_stats($CanvasLayer/Stats)


func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		$EnemyGenerator.start_next_wave()


func _on_AutoCollectZone_body_shape_entered(body_id, body, body_shape, area_shape):
	if body.name == "Character":
		MainNodes.get_character().is_in_auto_zone = true


func _on_AutoCollectZone_body_shape_exited(body_id, body, body_shape, area_shape):
	if body.name == "Character":
		MainNodes.get_character().is_in_auto_zone = false
