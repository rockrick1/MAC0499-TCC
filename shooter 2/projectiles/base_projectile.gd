extends Area2D

export (float) var speed
export (int) var damage
export (float) var life

export (int) var dist_threshold = 25
export (int) var graze_threshold = 10

export (bool) var set_dir

var direction
var shooter
var stage
var generator
var enemy
var character

var grazed = false

var wr

func _ready():
	pass
	# circus mode
#	$Sprite.set_self_modulate(Color(randf(), randf(), randf()))

func set_vars(sh, dir, rotate):
	direction = dir
	shooter = sh
	
	character = MainNodes.get_character()
	stage = MainNodes.get_stage()
	set_life()
	character.connect("bomb", self, "on_bomb")

	if rotate and set_dir:
		set_rotation(dir.angle())

	enemy = shooter.enemy
	
	wr = weakref(shooter)
	
	if enemy:
		stage.add_bullet()
	set_process(true)

func set_life(l = 5):
	if l:
		life = l
	$DeathTimer.wait_time = life


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	position += direction * speed * _delta * 50


func _on_Projectile_body_entered(body):
	if body.has_method("take_damage"):
		if body.invincible:
			return
		body.take_damage(damage)
		if wr.get_ref() and shooter.has_method("update_stats_display"):
			shooter.stats.shots_hit += 1
			shooter.update_stats_display()
	die()


func get_dist_to_char():
	return get_global_position().distance_to(character.get_global_position())


func is_on_screen():
	var pos = get_global_position()
	if pos.x < stage.start_border.x or pos.x > stage.end_border.x or pos.y < stage.start_border.y or pos.y > stage.end_border.y:
		return false
	return true


# Every time the CharSearchRefresh timer timeouts, the projectile will check if
# the character is close enough to the bullet, and activate the collision if he is
func _on_CharSearchRefresh_timeout():
	if character != null and get_dist_to_char() < dist_threshold:
#		$Sprite.set_modulate(Color(200,200,200,1))
		$Collision.set_disabled(false)
		if get_dist_to_char() < graze_threshold and not grazed:
			grazed = true
			character.graze()

	elif enemy:
#		$Sprite.set_modulate(Color(1,1,1,1))
		$Collision.set_disabled(true)
	if not is_on_screen():
		die()


func on_bomb():
	if enemy:
		die()


func die():
	if enemy:
		stage.remove_bullet()
	queue_free()


func _on_DeathTimer_timeout():
	die()
