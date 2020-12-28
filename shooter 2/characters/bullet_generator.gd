extends Node2D


var proj

var shooting = false
var can_shoot = true
var shooter
var character
var stage

var modul = false

var active_projectiles = []

"""
Variables: {
	proj_type
	life
	bullets_per_array
	individual_array_spread
	total_bullet_arrays
	total_array_spread
	base_spin_speed
	spin_speed_period
	spin_variation
	aim_at_character
	fire_rate
	cycles_per_interval
	bullet_speed
	bullet_life
	bullet_color
}
"""

########################### Generator base variables ###########################

export (String) var proj_type

# Time in seconds the generator stays active
export (float) var life
# Time in seconds the generator takes to start
export (float) var start_delay

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

# Overrides array angle with direction to character if true
export (bool) var aim_at_character

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
var mod_spin_speed = 1
var mod_fire_rate = 1
var mod_bullet_speed = 0

################################################################################

export (bool) var DEBUG

func _ready():
	set_process(false)
	shooter = get_parent().get_parent()
	print(shooter)


# Sets the patterns parameters
func set_params(params, proj_type, start_delay):
	self.proj_type = proj_type
	self.start_delay = start_delay
	$StartTimer.wait_time = start_delay
	life = params.life
	$LifeTimer.wait_time = life
	proj = load("res://projectiles/enemy/"+proj_type+".tscn")
	bullets_per_array = params.bullets_per_array
	individual_array_spread = params.individual_array_spread
	total_bullet_arrays = params.total_bullet_arrays
	total_array_spread = params.total_array_spread
	base_spin_speed = params.base_spin_speed
	spin_speed = base_spin_speed
	spin_speed_period = params.spin_speed_period
	spin_variation = params.spin_variation
	aim_at_character = params.aim_at_character
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
		"aim_at_character" : aim_at_character,
		"fire_rate" : fire_rate,
		"bullet_speed" : bullet_speed,
		"bullet_life" : bullet_life,
		"bullet_color" : bullet_color
	}


func set_fire_rate(rate, modifier):
	fire_rate = rate
	$FireRate.wait_time = 1/float(fire_rate * modifier)


func set_spin_speed(speed, modifier):
	base_spin_speed = speed
	spin_speed = speed


# Starts the StartTimer if there is a time to wait, otherwise, starts shooting
func start_on_timer():
	print("VO COMEÇAR DEPOIS DESSE TEMPO AQUI")
	print(start_delay)
	print($StartTimer.wait_time)
	if start_delay == 0:
		start()
	else:
		$StartTimer.start()

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
	current_rotation = fmod(current_rotation + (spin_speed * mod_spin_speed)*delta, 360)
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
		
		var proj_instance
		var start_angle = 0
		var angle_between_bullets
		var angle
		var dir
		
		# Apply bullets per array modifier
		var actual_bullets_per_array = bullets_per_array + mod_bullets_per_array
		
		for _array in range(total_bullet_arrays):
			
			if bullets_per_array != 0:
				angle_between_bullets = individual_array_spread/actual_bullets_per_array
			
			for bullet_n in range(actual_bullets_per_array):
				if not aim_at_character:
					angle = deg2rad((angle_between_bullets * bullet_n) + start_angle)
					dir = Vector2(cos(angle), sin(angle))
				else:
					dir = -(get_global_position() - character.get_global_position()).normalized()
					var offset = 0
					if actual_bullets_per_array > 1:
						angle_between_bullets = individual_array_spread/(actual_bullets_per_array - 1)
						offset = -individual_array_spread/2 + (angle_between_bullets * bullet_n) 
					dir = dir.rotated(deg2rad(offset))

				proj_instance = proj.instance()
				
				if not aim_at_character:
					dir = dir.rotated(deg2rad(current_rotation)).normalized()
				proj_instance.set_vars(shooter, dir, true)
				proj_instance.position = shooter.get_global_position()
				proj_instance.generator = self
				proj_instance.speed = bullet_speed + mod_bullet_speed
				proj_instance.set_life(bullet_life)
#				proj_instance.get_node("Sprite").set_self_modulate(bullet_color)
				stage.add_child_below_node(character, proj_instance)

			start_angle += total_array_spread


func update_diff(overall_diff):
	"""
	Currently moddable attributes are:
		fire rate
		bullet speed
		bullets per array
	"""
	
	if overall_diff > 1:
		mod_bullet_speed = pow(overall_diff, 0.0503) - 1
		if overall_diff < 200:
			mod_bullet_speed = mod_bullet_speed / pow(200/overall_diff, 0.7)

		mod_spin_speed = 1
		set_spin_speed(base_spin_speed, mod_spin_speed)
		
		mod_fire_rate = (log(overall_diff) / log(10)) / 2
		if mod_fire_rate <= 1:
			mod_fire_rate = 1
		set_fire_rate(fire_rate, mod_fire_rate)
	
	if overall_diff < 300:
		mod_bullets_per_array = 0
	else:
		mod_bullets_per_array = 1


func _on_FireRate_timeout():
	can_shoot = true


func _on_LifeTimer_timeout():
	die()


func die():
	queue_free()

	
func _on_StartTimer_timeout():
	print("SOU UM GENERATOR, VOU COMEÇAR, COM LICENÇA " + proj_type)
	start()
