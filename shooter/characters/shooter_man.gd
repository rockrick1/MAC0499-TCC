extends "res://characters/enemy.gd"


export (float) var fire_rate
export (String) var proj_type
export (float) var fire_sway

var shooter
var arena
var proj_scene
var muzzle_pos

func flip_v(flip):
	$Sprite.set_flip_v(flip)
	if flip:
		$Muzzle.position = Vector2(muzzle_pos.x, -muzzle_pos.y)
	else:
		$Muzzle.position = muzzle_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	proj_scene = load("res://projectiles/" + proj_type + "_proj.tscn")
	arena = get_parent()
	muzzle_pos = $Muzzle.get_position()
	$FireCD.set_wait_time(fire_rate)
	$FireCD.start()

func shoot(dir):
#	shooter.stats.shots_fired += 1
#	shooter.update_stats_display()
	proj_dir = character.get_node("Center").get_global_position() - $Muzzle.get_global_position()
	$FireCD.start()
	
	print($Muzzle.get_global_position())
	var proj_instance = proj_scene.instance()
	proj_instance.position = $Muzzle.get_global_position()
	var sway = deg2rad((randf() - 0.5)*fire_sway)
	proj_instance.set_direction(proj_dir.rotated(sway))
	proj_instance.shooter = self
	arena.add_child_below_node(arena.get_node(get_name()) ,proj_instance)


func _on_FireCD_timeout():
	shoot(self.dir)
