extends Area2D


export (Vector2) var dir = Vector2(0,35)

var character
var follow = false


func _ready():
	character = MainNodes.get_character()


func _process(delta):
	if follow:
		dir = -(get_global_position() - character.get_global_position()).normalized() * 170
	self.position += dir*delta
	if character.is_in_auto_zone:
		follow = true


func die():
	queue_free()


func _on_DeathTimer_timeout():
	character.gain_drop()
	die()


func _on_Drop_body_shape_entered(body_id, body, body_shape, area_shape):
	# Collision with the sage border's bottom kills drop
	if area_shape == 1 and body.get_name() == "StageBorder" and body_shape == 3:
		die()
	# Collision of PlayerFollow and Character will move drop to character
	# and run pickup
	elif body.get_name() == "Character":
		if area_shape == 1:
			character.gain_drop()
			die()
		follow = true
	
	
