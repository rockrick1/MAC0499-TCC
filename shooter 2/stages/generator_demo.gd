extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var stats

var n_bullets = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	stats = $CanvasLayer/Stats
	MainNodes.set_stage(self)
	$CanvasLayer/GeneratorController.set_enemy($Enemies/Enemy)
	MainNodes.set_character($Character)


func add_bullet():
	n_bullets += 1
	stats.update_bullets(n_bullets)


func remove_bullet():
	n_bullets -= 1
	stats.update_bullets(n_bullets)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		return
