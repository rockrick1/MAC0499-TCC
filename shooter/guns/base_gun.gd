extends Node

export (float) var fire_rate
export (String) var proj_type
export (float) var fire_sway

var shooter
var arena
var proj_scene
var muzzle_pos
var can_fire
var tween

func flip_v(flip):
	$Sprite.set_flip_v(flip)
	if flip:
		$Muzzle.position = Vector2(muzzle_pos.x, -muzzle_pos.y)
	else:
		$Muzzle.position = muzzle_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	can_fire = true
	proj_scene = load("res://projectiles/" + proj_type + "_proj.tscn")
	shooter = get_parent()
	arena = get_parent().get_parent()
	muzzle_pos = $Muzzle.get_position()
	$Cooldown.set_wait_time(fire_rate)
	tween = $Tween

func shoot(dir):
	if can_fire:
		can_fire = false
		$Cooldown.start()
		
		$Sprite.position.x = -2
		tween.interpolate_property($Sprite, "position",
		Vector2($Sprite.position.x, $Sprite.position.y),
		Vector2(0, $Sprite.position.y), .2,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

		
		var proj_instance = proj_scene.instance()
		proj_instance.position = $Muzzle.get_global_position()
		var sway = deg2rad((randf() - 0.5)*fire_sway)
		proj_instance.set_direction(dir.rotated(sway))
		proj_instance.shooter = shooter
		arena.add_child_below_node(shooter, proj_instance)


func _on_Cooldown_timeout():
	can_fire = true
