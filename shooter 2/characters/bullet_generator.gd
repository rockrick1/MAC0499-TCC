extends Node2D


const proj1 = preload("res://projectiles/proj1.tscn")

var shooting = false
var can_shoot = true
var shooter
var arena

var modul = false

var active_projectiles = []

# Amount of bullets in an array
export (int) var bullets_per_array = 4
# Angle of spread of the whole array
export (float) var individual_array_spread = 135

# Numer of arrays
export (int) var total_bullet_arrays = 3
# Spread between different arrays
export (float) var total_array_spread = 120

# "Character" spin speed
export (float) var spin_speed = 0
var current_spin_speed = spin_speed
export (float) var spin_speed_period = .5
export (float) var spin_variation = 200
var current_spin = 0

# fire rate in bullets/sec
export (float) var fire_rate = 25
export (float) var fire_interval = 0
export (float) var bullet_speed = 1
export (float) var bullet_life = 5

var n_bullets = 0

export (Color) var bullet_color = Color(1, 1, 1)


func _ready():
	set_process(false)
	print(spin_speed)
	shooter = get_parent()
	print(shooter)
	$FireRate.wait_time = 1/fire_rate


# sets the patterns parameters
func set_params(params):
	$FireRate.wait_time = 1/fire_rate


func start():
	set_process(true)
	arena = shooter.arena
	shooting = true


func modulate_bullets():
	bullet_color = Color(0.996078, 0.333333, 0.333333)


func change_current_spin_speed():
	if not $SpinSpeed.is_active():
		print(str(current_spin_speed) + " -> " + str(spin_speed + spin_variation))
		$SpinSpeed.interpolate_property(self, "current_spin_speed",
		current_spin_speed,
		spin_speed + spin_variation,
		spin_speed_period,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$SpinSpeed.start()
		spin_variation = -spin_variation

func _process(delta):
	current_spin = (current_spin + current_spin_speed*delta)
	
	change_current_spin_speed()
#	print(current_spin_speed)
	
	if current_spin > 360:
		current_spin -= 360
	if shooting and can_shoot:
		can_shoot = false
		$FireRate.start()
		
		var proj1_instance
		var start_angle = 0
		var angle_between_bullets
		var angle
		var dir
		
		for array in range(total_bullet_arrays):
			
			angle_between_bullets = individual_array_spread/bullets_per_array
			
			for bullet_n in range(bullets_per_array):
				angle = deg2rad((angle_between_bullets * bullet_n) + start_angle)
				dir = Vector2(cos(angle), sin(angle))
				
				proj1_instance = proj1.instance()
				proj1_instance.set_direction(dir.rotated(deg2rad(current_spin)))
				proj1_instance.shooter = shooter
				proj1_instance.generator = self
				proj1_instance.position = shooter.get_global_position()
				proj1_instance.speed = bullet_speed
				proj1_instance.set_life(bullet_life)
				proj1_instance.get_node("Sprite").set_self_modulate(bullet_color)
				n_bullets += 1
				arena.stats.update_stats(n_bullets)
				shooter.arena.add_child_below_node(shooter.arena.get_node("Character"), proj1_instance)
				
			start_angle += total_array_spread


func _on_FireRate_timeout():
	can_shoot = true
