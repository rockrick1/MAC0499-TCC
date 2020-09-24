extends Area2D


export (Vector2) var dir = Vector2(0,35)

var character
var follow = false


func _ready():
	character = MainNodes.get_character()


func _process(delta):
	if follow:
		dir = -(get_global_position() - character.get_global_position()).normalized() * 120
		if $DeathTimer.is_stopped():
			$DeathTimer.start()
	self.position += dir*delta


func die():
	queue_free()


func _on_Drop_body_entered(body):
	follow = true


func _on_DeathTimer_timeout():
	character.gain_drop()
	die()
