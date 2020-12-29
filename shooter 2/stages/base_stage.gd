extends Node2D


export (bool) var is_demo

var stats

var start_border = Vector2(128,0)
var end_border = Vector2(384,300)

var n_bullets = 0

var overall_difficulty = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	stats = $CanvasLayer/Stats
	MainNodes.set_stage(self)
	MainNodes.set_character($Character)


func add_bullet():
	n_bullets += 1
	stats.update_bullets(n_bullets)


func remove_bullet():
	n_bullets -= 1
	stats.update_bullets(n_bullets)


func update_diff(no_hit_time, grazed_bullets):
#	if is_demo:
#		return
	var core_action_points = 0
	
	var no_hit_points = 0
	var graze_points = 0
	
	# Points gained from not getting hit, considering time and amount of
	# bullets on screen
	no_hit_points = pow(no_hit_time, 1.15) * n_bullets / 20000
	graze_points = grazed_bullets * pow(overall_difficulty + 1, 0.42)

	core_action_points = no_hit_points + graze_points
	
	var accumulated_diff = core_action_points / 2
	overall_difficulty += accumulated_diff

	stats.update_diff(accumulated_diff, overall_difficulty)

	# Updates stars speed according to diff
	$Background/Stars.update_diff(overall_difficulty)
	
	for enemy in $Enemies.get_children():
		for generator in enemy.get_node("Generators").get_children():
			generator.update_diff(overall_difficulty)


func game_over():
	$CanvasLayer.queue_free()
	$Background/Stars.queue_free()
	$Enemies.queue_free()
	$EnemyGenerator.queue_free()
	$Music.stop()
	for proj in get_children():
		if "Projectile" in proj.name or "Drop" in proj.name:
			proj.queue_free()
