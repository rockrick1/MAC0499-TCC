extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	$Enemies/Enemy1/BulletGenerator.start()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_select"):
		$Enemies/Enemy1/BulletGenerator.start()
#		$Enemies/Enemy1/BulletGenerator2.modulate_bullets()
#		$Enemies/Enemy1/BulletGenerator2.start()
