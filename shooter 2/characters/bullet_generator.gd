extends Node2D


const proj1 = preload("res://projectiles/proj1.tscn")

var shooting = false
var can_shoot = true
var shooter
var arena

var active_projectiles = []

# Amount of bullets in an array
export (int) var bullets_per_array = 4
# Angle of spread of the whole array
export (float) var individual_array_spread = 135

# Numer of arrays
export (int) var total_bullet_arrays = 2
# Spread between different arrays
export (float) var total_array_spread = 180

# "Character" spin speed
export (float) var spin_speed = 120
export (float) var spin_speed_period = 3
export (float) var max_spin_speed = 360
var current_spin = 0

# fire rate in bullets/sec
export (float) var fire_rate = 15
export (float) var fire_interval = 0
export (float) var bullet_speed = 1
export (float) var bullet_life = 5


func _ready():
	shooter = get_parent()
	arena = shooter.arena
	$FireRate.wait_time = 1/fire_rate
	pass


# sets the patterns parameters
func set_params(params):
	$FireRate.wait_time = 1/fire_rate
	pass


func start():
	shooting = true
	pass


func get_proj_pos(array, bullet_n):
	pass


func change_spin_speed():
	if $SpinSpeed.is_active():
		return
	$SpinSpeed.interpolate_property($Center, "spin_speed",
	spin_speed,
	max_spin_speed,
	spin_speed_period,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$SpinSpeed.start()

func _process(delta):
	
	current_spin = (current_spin + spin_speed*delta)
	
	
	change_spin_speed()
	print(spin_speed)
	
	if current_spin > 360:
		current_spin -= 360
	if shooting and can_shoot:
		can_shoot = false
		$FireRate.start()
		
		var proj1_instance
		var start_angle = 0
		for array in range(total_bullet_arrays):
			
			var angle_between_bullets = individual_array_spread/bullets_per_array
			
			for bullet_n in range(bullets_per_array):
				var angle = deg2rad((angle_between_bullets * bullet_n) + start_angle)
				var dir = Vector2(cos(angle), sin(angle))
				
				proj1_instance = proj1.instance()
				proj1_instance.set_direction(dir.rotated(deg2rad(current_spin)))
				proj1_instance.shooter = shooter
				proj1_instance.position = shooter.get_global_position()
				proj1_instance.speed = bullet_speed
				proj1_instance.set_life(bullet_life)
				shooter.arena.add_child_below_node(shooter.arena.get_node("Character"), proj1_instance)
				
			
			start_angle += total_array_spread
	pass


func _on_FireRate_timeout():
	can_shoot = true
