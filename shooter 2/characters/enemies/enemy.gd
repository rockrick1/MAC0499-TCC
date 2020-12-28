extends RigidBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var HIT_REWARD
export (int) var NUM_DROPS
export (String) var TYPE
export (float) var DISTANCE
export (float) var BOMB_DMG = 20

export (float) var amount_to_move
export (float) var where_to_move
export (float) var move_period

export (Array) var generator_scripts

const base_generator = preload("res://characters/bullet_generator.tscn")
const drop_spawner = preload("res://drops/drop_spawner.tscn")
const enemy = true

var character
var stage
var dir
var proj_dir
var muzzlepos
var pos_h_override
var spawned_drops = 0
var exit_time = -1

var invincible = false
var is_dead = false
var exit = false


func _ready():
	stage = get_parent().get_parent()
	character = stage.get_node("Character")
	character.connect("bomb", self, "on_bomb")
	if has_node("ColorRect"):
		$ColorRect.set_frame_color(Color(randf(), randf(), randf()))
	start()


func start():
	set_generators(generator_scripts)
	run_move("enter")


func start_life():
	if exit_time != -1:
		print("EU VO SAIR DAQUI UM DIA")
		$ExitTimer.wait_time = exit_time
		$ExitTimer.start()


func run_move(name):
	var move_pattern
	if "exit_l" in name:
		exit = true
		move_pattern = Vector2(-150, 0)
	elif "exit_r" in name:
		exit = true
		move_pattern = Vector2(150, 0)
	elif "exit_center" in name:
		exit = true
		move_pattern = Vector2(0,-75)
		
	if $Move:
		if move_pattern != null:
			$Move.interpolate_property(self, "position",
			get_position(),
			get_position() + move_pattern,
			2,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		else:
			$Move.interpolate_property(self, "position:y",
			get_position().y,
			where_to_move,
			2,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Move.start()


func set_generators(generators):
	if generators:
		for generator in generators:
			# presets the generator will use
			var script = generator.s
			# projectile type for the generator
			var proj_type = generator.pt
			# time in seconds the generator takes to start after enemy spawns
			var start_delay = generator.delay
			var g = base_generator.instance()
			var params = DBManager.get_bullet_gen(script)
			# life time override
			if generator.has('l'):
				params.life = generator.l
			g.set_params(params, proj_type, start_delay)
			$Generators.add_child(g)


func spawn_drops():
	var spawner_instance = drop_spawner.instance()
	spawner_instance.num_drops = NUM_DROPS
	spawner_instance.stage = stage
	spawner_instance.spawned_drops = 0
	spawner_instance.global_position = get_global_position()
	stage.add_child(spawner_instance)


# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	if HP <= 0:
		die(true)


func on_bomb():
	take_damage(BOMB_DMG)


func die(spawn_drops):
	if not exit:
		kill_generators()
		character.stats.enemies_killed += 1
		character.update_stats_display()
	$Move.stop_all()
	
	# Prevents method from being called multiple times when getting hit
	# by multiple projectiles in the same frame
	# Only spawns drops if killed by the player
	if not is_dead and spawn_drops:
		is_dead = true
		spawn_drops()
	queue_free()


func kill_generators():
	for generator in $Generators.get_children():
		generator.die()


func _on_Move_tween_all_completed():
	# When a tween is completed, starts generators if is not an exit tween
	if not exit:
		# Starts the enemies life time (that is, enemy exit time counts after
		# generators have started)
		for generator in $Generators.get_children():
			generator.start_on_timer()
		start_life()
	# Kills enemy if exit tween, and doesnt spawn drops
	else:
		die(false)


# Enemy will exit the screen and die after a certain period of time
func _on_ExitTimer_timeout():
	kill_generators()
	print("vo embora por ","exit_"+pos_h_override)
	run_move("exit_" + pos_h_override)
