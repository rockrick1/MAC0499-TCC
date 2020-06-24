extends KinematicBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var HIT_REWARD

const enemy = true

var character
var dir
var muzzlepos

func _ready():
	character = get_parent().get_node("Character")
	if has_node("Muzzle"):
		muzzlepos = $Muzzle.get_position()

# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	$Particles2D.restart()
	if HP <= 0:
		die()

func _process(delta):
	dir = character.get_node("Center").get_global_position() - get_position()
	if dir.x < 0:
		$AnimatedSprite.set_flip_h(true)
		if muzzlepos != null:
			$Muzzle.position.x = -(muzzlepos.x)
	else:
		$AnimatedSprite.set_flip_h(false)
		if muzzlepos != null:
			$Muzzle.position.x = muzzlepos.x
	var mot = dir.normalized() * RUN_SPEED
	if delta != 0:
		move_and_slide(mot/delta)

func die():
	character.stats.enemies_killed += 1
	character.update_stats_display()
	queue_free()
