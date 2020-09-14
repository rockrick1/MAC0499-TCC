extends Node2D


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


func update_diff(accumulated_diff, overall_diff, no_hit_time):
	var core_action_points = 0
	
	var no_hit_points = 0
	var graze_points = 0
	
	# Points gained from not getting hit, considering time and amount of
	# bullets on screen
	no_hit_points = pow(no_hit_time, 1.15) * n_bullets / 500
	core_action_points = no_hit_points + graze_points
	
	accumulated_diff = core_action_points / 2
	overall_diff = floor(overall_diff + accumulated_diff)
	
	
	overall_difficulty = overall_diff
	stats.update_diff(accumulated_diff, overall_difficulty)
	
	for enemy in $Enemies.get_children():
		for generator in enemy.get_node("Generators").get_children():
			generator.update_diff(overall_difficulty)
	
