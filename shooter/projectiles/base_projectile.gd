extends Node2D

export (float) var speed
export (int) var damage

var direction
var shooter

func set_direction(dir):
	direction = dir
	set_rotation(dir.angle())
	set_process(true)

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	position += direction * speed

func _on_Area2D_body_entered(body):
	if body != shooter:
		if body.has_method("take_damage"):
			print("Acertou!")
			body.take_damage(damage)
			shooter.stats.shots_hit += 1
			shooter.update_stats_display()
			queue_free()

func _on_DeathTimer_timeout():
	queue_free()
