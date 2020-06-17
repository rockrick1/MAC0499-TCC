extends KinematicBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var FIRE_REWARD

var character

func _ready():
	character = get_parent().get_node("Character")

# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	$Particles2D.restart()
	if HP <= 0:
		die()

func _process(delta):
	var dir = character.get_position() - get_position()
	if dir.x < 0:
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)
	var mot = dir.normalized() * RUN_SPEED
	if delta != 0:
		move_and_slide(mot/delta)

func die():
	character.stats.enemies_killed += 1
	character.update_stats_display()
	queue_free()
