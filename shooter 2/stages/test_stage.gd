extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var stats

var n_bullets = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	stats = $CanvasLayer/Stats
	MainNodes.set_arena(self)
	MainNodes.set_character($Character)
#	$Enemies/Enemy1/BulletGenerator.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		var params = DBManager.get_vars("generators/spinning6")
		print(params.base_spin_speed)
		$Enemies/Enemy1/BulletGenerator.set_params(params)
		$Enemies/Enemy1/BulletGenerator.start()
		params.base_spin_speed = -60
		$Enemies/Enemy1/BulletGenerator2.set_params(params)
		$Enemies/Enemy1/BulletGenerator2.modulate_bullets(Color(.1,.35,1,1))
		$Enemies/Enemy1/BulletGenerator2.start()
