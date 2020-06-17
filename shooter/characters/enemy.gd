extends KinematicBody2D

var RUN_SPEED = 1
var HP = 100
var FIRE_REWARD = 1

# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	$Particles2D.restart()
	if HP <= 0:
		die()

func _process(delta):
	var dir = get_parent().get_node("Character").get_position() - get_position()
	if dir.x < 0:
		$AnimatedSprite.set_flip_h(true)
	else:
		$AnimatedSprite.set_flip_h(false)
	var mot = dir.normalized() * RUN_SPEED
	if delta != 0:
		move_and_slide(mot/delta)

func die():
	queue_free()
