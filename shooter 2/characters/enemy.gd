extends RigidBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var HIT_REWARD
export (String) var TYPE
export (float) var DISTANCE

export (float) var amount_to_move
export (float) var move_period

export (String) var generator_scripts

const enemy = true

var character
var stage
var dir
var proj_dir
var muzzlepos


func _ready():
	stage = get_parent().get_parent()
	character = stage.get_node("Character")
	print(get_global_position())
	position = Vector2(256,-15)
	
	var params = DBManager.get_vars("generators/spinning6")
	
	$Generators/BulletGenerator.set_params(params)
	params.base_spin_speed = -80
	params.fire_rate = 12
	$Generators/BulletGenerator2.set_params(params)
	$Generators/BulletGenerator2.modulate_bullets(Color(.1,.35,1,1))
	
	if $StartMove:
		$StartMove.interpolate_property(self, "position",
		get_global_position(),
		get_global_position() + Vector2(0,amount_to_move),
		2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$StartMove.start()

# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	$Particles2D.restart()
	if HP <= 0:
		die()

func _process(delta):
#	dir = character.get_node("Center").get_global_position() - get_position()
##	$Center.clear_points()
##	$Center.add_point(character.get_node("Center").get_global_position() - Vector2(1,0))
##	$Center.add_point(character.get_node("Center").get_global_position() + Vector2(1,0))
##
##	$Muzzle2.clear_points()
##	$Muzzle2.add_point($Muzzle.get_global_position() - Vector2(1,0))
##	$Muzzle2.add_point($Muzzle.get_global_position() + Vector2(1,0))
#
#	if dir.x < 0:
#		$AnimatedSprite.set_flip_h(true)
#		if muzzlepos != null:
#			$Muzzle.position.x = -(muzzlepos.x)
#	else:
#		$AnimatedSprite.set_flip_h(false)
#		if muzzlepos != null:
#			$Muzzle.position.x = muzzlepos.x
#	var mot = dir.normalized() * RUN_SPEED
#	if delta != 0:
#		if TYPE == "Melee":
#			move_and_slide(mot/delta)
#		elif TYPE == "Ranged" and dir.length() > DISTANCE:
#			move_and_slide(mot/delta)
	pass

func die():
	character.stats.enemies_killed += 1
	character.update_stats_display()
	queue_free()


func _on_StartMove_tween_all_completed():
	for generator in $Generators.get_children():
		generator.start()
