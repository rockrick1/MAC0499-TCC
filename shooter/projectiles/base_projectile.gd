extends Node2D

export (float) var speed
export (int) var damage

var direction
var shooter

func set_direction(dir):
	direction = dir
	set_rotation(dir.angle())

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	position += direction * speed

func _on_Area2D_body_entered(body):
	if body != shooter:
		if body.has_method("take_damage"):
			body.take_damage(damage)
			queue_free()

func _on_DeathTimer_timeout():
	queue_free()