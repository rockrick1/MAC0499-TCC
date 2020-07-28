extends KinematicBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var HIT_REWARD
export (String) var TYPE
export (float) var DISTANCE

const enemy = true

var character
var arena
var dir
var proj_dir
var muzzlepos


func _ready():
	arena = get_parent().get_parent()
	character = arena.get_node("Character")
#	if has_node("Muzzle"):
#		muzzlepos = $Muzzle.get_position()

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
