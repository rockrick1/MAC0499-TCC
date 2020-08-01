extends Area2D

export (float) var speed
export (int) var damage
export (float) var life

export (int) var dist_threshold = 20

var direction
var shooter
var generator
var enemy

var wr

func _ready():
	enemy = shooter.enemy
	wr = weakref(shooter)
	set_life()

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
	# Only checks collision with the nearest bullets
	if MainNodes.get_character() != null and get_global_position().distance_to(MainNodes.get_character().get_global_position()) < dist_threshold:
		$Sprite.set_modulate(Color(1,0,0,1))
		$CollisionShape2D.set_disabled(false)
	elif enemy:
		$Sprite.set_modulate(Color(1,1,1,1))
		$CollisionShape2D.set_disabled(true)
	position += direction * speed


func _on_Projectile_body_entered(body):
	if body.has_method("take_damage") and body.enemy != enemy:
		body.take_damage(damage)
		if wr.get_ref() and shooter.has_method("update_stats_display"):
			shooter.stats.shots_hit += 1
			shooter.update_stats_display()
	die()


func _on_DeathTimer_timeout():
	die()


func die():
	if wr.get_ref() and generator != null:
		MainNodes.get_arena().n_bullets -= 1
	queue_free()

