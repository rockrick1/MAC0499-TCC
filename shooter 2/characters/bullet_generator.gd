extends Node2D


const proj1 = preload("res://projectiles/proj2.tscn")

var shooting = false
var can_shoot = true
var shooter
var character
var stage

var modul = false

var active_projectiles = []

"""
Variables: {
	life
	bullets_per_array
	individual_array_spread
	total_bullet_arrays
	total_array_spread
	base_spin_speed
	spin_speed_period
	spin_variation
	fire_rate
	cycles_per_interval
	bullet_speed
	bullet_life
	bullet_color
}
"""

########################### Generator base variables ###########################

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

# Origin spin speed
export (float) var base_spin_speed
# Angle variation during the spin speed period
export (float) var spin_variation
export (float) var spin_speed_period
# Current spin speed
var spin_speed
# Auxiliary variable
var next_variation
var current_rotation = 0

# Fire rate in bullets/sec
export (float) var fire_rate
# A cycle would be one iteration of all the bullet arrays
var current_cycle = 0

# Bullet vars
export (float) var bullet_speed
export (float) var bullet_life
export (Color) var bullet_color = Color(1, 1, 1)


############################# Difficulty modifiers #############################

var mod_bullets_per_array = 0
var mod_spin_speed = 0
var mod_fire_rate = 0
var mod_bullet_speed = 0

################################################################################

export (bool) var DEBUG


func _ready():
	set_process(false)
	shooter = get_parent().get_parent()
	print(shooter)


# Sets the patterns parameters
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
	bullet_speed = params.bullet_speed
	bullet_life = params.bullet_life
	bullet_color = Color(
		params.bullet_color.r,
		params.bullet_color.g,
		params.bullet_color.b,
		params.bullet_color.a
	)
	$FireRate.wait_time = 1/float(fire_rate)


func get_params():
	return {
		"life" : life,
		"bullets_per_array" : bullets_per_array,
		"individual_array_spread" : individual_array_spread,
		"total_bullet_arrays" : total_bullet_arrays,
		"total_array_spread" : total_array_spread,
		"base_spin_speed" : base_spin_speed,
		"spin_speed_period" : spin_speed_period,
		"spin_variation" : spin_variation,
		"fire_rate" : fire_rate,
		"bullet_speed" : bullet_speed,
		"bullet_life" : bullet_life,
		"bullet_color" : bullet_color
	}


func set_fire_rate(rate, modifier):
	fire_rate = rate
	$FireRate.wait_time = 1/float(fire_rate + modifier)


func set_spin_speed(speed, modifier):
	base_spin_speed = speed
	spin_speed = speed


func start():
	set_process(true)
	shooting = true
	character = MainNodes.get_character()
	stage = MainNodes.get_stage()
	if (life > 0):
		$LifeTimer.start()


func stop():
	shooting = false
	$LifeTimer.stop()


func modulate_bullets(color):
	bullet_color = color


func change_current_spin_speed():
	if not $SpinSpeed.is_active():
		if next_variation == null or next_variation < 0:
			next_variation = spin_variation
		else:
			next_variation = -spin_variation
#		print(str(spin_speed) + " -> " + str(base_spin_speed + spin_variation))
		$SpinSpeed.interpolate_property(self, "spin_speed",
		spin_speed,
		base_spin_speed + next_variation,
		spin_speed_period,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$SpinSpeed.start()

func _process(delta):
#	print(get_name(), ': ', spin_speed, ' ', base_spin_speed)
#	print(get_name(), ': ', base_spin_speed,': ', current_rotation, ' -> ', fmod(current_rotation + spin_speed*delta, 360))
#	print(get_name(), ': ', spin_speed)
	current_rotation = fmod(current_rotation + (spin_speed + mod_spin_speed)*delta, 360)
	if spin_variation != 0:
		change_current_spin_speed()
#	print(spin_speed)
	
#	if DEBUG:
#		print(get_name(), ': ', $FireRate.wait_time, ' ')
#	if current_rotation > 360 or current_rotation :
#		current_rotation -= 360
	if shooting and can_shoot:
#		print(get_name(), ': ', spin_speed, ' ', base_spin_speed)
		can_shoot = false
		$FireRate.start()
		
		var proj1_instance
		var start_angle = 0
		var angle_between_bullets
		var angle
		var dir
		
		for array in range(total_bullet_arrays):
			
			if bullets_per_array != 0:
				angle_between_bullets = individual_array_spread/bullets_per_array
			
			for bullet_n in range(bullets_per_array + mod_bullets_per_array):
				angle = deg2rad((angle_between_bullets * bullet_n) + start_angle)
				dir = Vector2(cos(angle), sin(angle))
				
				proj1_instance = proj1.instance()
				
				proj1_instance.set_direction(dir.rotated(deg2rad(current_rotation)).normalized())
				proj1_instance.shooter = shooter
				proj1_instance.generator = self
				proj1_instance.position = shooter.get_global_position()
				proj1_instance.speed = bullet_speed + mod_bullet_speed
				proj1_instance.set_life(bullet_life)
#				proj1_instance.get_node("Sprite").set_self_modulate(bullet_color)
				stage.add_child_below_node(character, proj1_instance)

			start_angle += total_array_spread


func update_diff(overall_diff):
	if overall_diff < 5:
		mod_fire_rate = 0
		set_fire_rate(fire_rate, mod_fire_rate)

		mod_spin_speed = 0
		set_spin_speed(base_spin_speed, mod_spin_speed)

		mod_bullet_speed = 0

		mod_bullets_per_array = 0
	elif overall_diff < 10:
		mod_fire_rate = 5
		set_fire_rate(fire_rate, mod_fire_rate)

		mod_spin_speed = 5
		set_spin_speed(base_spin_speed, mod_spin_speed)

		mod_bullet_speed = 5

		mod_bullets_per_array = 5


func _on_FireRate_timeout():
	can_shoot = true


func _on_LifeTimer_timeout():
	die()


func die():
	queue_free()
