extends Node2D

export (float) var speed
export (int) var damage
export (float) var life

var direction
var shooter
var enemy

var wr

func _ready():
	enemy = shooter.enemy
	wr = weakref(shooter)

func set_direction(dir):
	direction = dir
	set_rotation(dir.angle())
	set_process(true)

func set_life(l = 5):
	if l:
		life = l
	$DeathTimer.wait_time = life

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	position += direction.normalized() * speed

func _on_Area2D_body_entered(body):
	if body != shooter:
		if body.has_method("take_damage") and body.enemy != enemy:
			body.take_damage(damage)
			if wr.get_ref() and shooter.has_method("update_stats_display"):
				shooter.stats.shots_hit += 1
				shooter.update_stats_display()
		queue_free()
			

func _on_DeathTimer_timeout():
	queue_free()
