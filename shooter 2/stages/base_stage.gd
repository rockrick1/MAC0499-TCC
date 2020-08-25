extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var stats

var start_border = Vector2(128,0)
var end_border = Vector2(384,300)

var n_bullets = 0


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
