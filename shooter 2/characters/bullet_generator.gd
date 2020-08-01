extends Node2D


const proj1 = preload("res://projectiles/proj1.tscn")

var shooting = false
var can_shoot = true
var shooter

var modul = false

var active_projectiles = []

"""
Variables: {
	life :
	bullets_per_array
	individual_array_spread
	total_bullet_arrays
	total_array_spread
	base_spin_speed
	spin_speed_period
	spin_variation
	fire_rate
	fire_interval
	bullet_speed
	bullet_life
	bullet_color
}
"""

# Time in seconds the generator stays active
export (float) var life
# Amount of bullets in an array
export (int) var bullets_per_array
# Angle of spread of the whole array
export (float) var individual_array_spread

# Numer of arrays
export (int) var total_bullet_arrays
# Spread between different arrays
export (float) var total_array_spread

# "Character" spin speed
export (float) var base_spin_speed
export (float) var spin_speed_period
export (float) var spin_variation
var spin_speed
var current_rotation = 0

# fire rate in bullets/sec
export (float) var fire_rate
export (float) var fire_interval
export (float) var bullet_speed
export (float) var bullet_life

var n_bullets = 0

export (Color) var bullet_color = Color(1, 1, 1)


func _ready():
	set_process(false)
	shooter = get_parent()
	print(shooter)


# sets the patterns parameters
func set_params(params):
	life = params.life
	$LifeTimer.wait_time = life
	bullets_per_array = params.bullets_per_array
	individual_array_spread = params.individual_array_spread
	total_bullet_arrays = params.total_bullet_arrays
	total_array_spread = params.total_array_spread
	base_spin_speed = params.base_spin_speed
	spin_speed = base_spin_speed
	spin_speed_period = params.spin_speed_period
	spin_variation = params.spin_variation
	fire_rate = params.fire_rate
	fire_interval = params.fire_interval
	bullet_speed = params.bullet_speed
	bullet_life = params.bullet_life
	bullet_color = Color(
		params.bullet_color.r,
		params.bullet_color.g,
		params.bullet_color.b,
		params.bullet_color.a
	)

	$FireRate.wait_time = 1/fire_rate


func start():
	set_process(true)
	shooting = true
	if (life > 0):
		$LifeTimer.start()


func modulate_bullets(color):
	bullet_color = color


func change_current_spin_speed():
	if not $SpinSpeed.is_active():
		print('henlo guys')
#		print(str(spin_speed) + " -> " + str(base_spin_speed + spin_variation))
		$SpinSpeed.interpolate_property(self, "spin_speed",
		spin_speed,
		base_spin_speed + spin_variation,
		spin_speed_period,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$SpinSpeed.start()
		spin_variation = -spin_variation

func _process(delta):
	print(get_name(), ': ', spin_speed, ' ', base_spin_speed)
#	print(get_name(), ': ', base_spin_speed,': ', current_rotation, ' -> ', fmod(current_rotation + spin_speed*delta, 360))
#	print(get_name(), ': ', spin_speed)
	current_rotation = fmod(current_rotation + spin_speed*delta, 360)
	if spin_variation != 0:
		change_current_spin_speed()
#	print(spin_speed)
	
	
#	if current_rotation > 360 or current_rotation :
#		current_rotation -= 360
	if shooting and can_shoot:
		can_shoot = false
		$FireRate.start()
		
		var proj1_instance
		var start_angle = 0
		var angle_between_bullets
		var angle
		var arena = MainNodes.get_arena()
		var character = MainNodes.get_character()
		var dir
		
		for array in range(total_bullet_arrays):
			
			angle_between_bullets = individual_array_spread/bullets_per_array
			
			for bullet_n in range(bullets_per_array):
				angle = deg2rad((angle_between_bullets * bullet_n) + start_angle)
				dir = Vector2(cos(angle), sin(angle))
				
				proj1_instance = proj1.instance()
				
				proj1_instance.set_direction(dir.rotated(deg2rad(current_rotation)))
				proj1_instance.shooter = shooter
				proj1_instance.generator = self
				proj1_instance.position = shooter.get_global_position()
				proj1_instance.speed = bullet_speed
				proj1_instance.set_life(bullet_life)
				proj1_instance.get_node("Sprite").set_self_modulate(bullet_color)

				arena.n_bullets += 1
				arena.stats.update_stats(arena.n_bullets)

				arena.add_child_below_node(character, proj1_instance)
				
			start_angle += total_array_spread


func _on_FireRate_timeout():
	can_shoot = true


func _on_LifeTimer_timeout():
	die()


func die():
	queue_free()
