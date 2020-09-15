extends "base_stage.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/GeneratorController.set_enemy($Enemies/Enemy)
	$Enemies/Enemy/ExitTimer.stop()
