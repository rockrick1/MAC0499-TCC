extends RigidBody2D

export (float) var RUN_SPEED
export (float) var HP
export (float) var HIT_REWARD
export (int) var NUM_DROPS
export (String) var TYPE
export (float) var DISTANCE

export (float) var amount_to_move
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
var move_pattern
var pos_override
var spawned_drops = 0


var exit = false


func _ready():
	stage = get_parent().get_parent()
	character = stage.get_node("Character")
	$ColorRect.set_frame_color(Color(randf(), randf(), randf()))
	start()


func start():
	set_generators(generator_scripts)
	run_move("enter")


func run_move(name):
	match name:
		"enter":
			move_pattern = Vector2(0, 75)
		"exit_left":
			exit = true
			move_pattern = Vector2(-150, 0)
		"exit_right":
			exit = true
			move_pattern = Vector2(150, 0)
		"exit_center":
			exit = true
			move_pattern = Vector2(0,-75)

	if $Move:
		$Move.interpolate_property(self, "position",
		get_position(),
		get_position() + move_pattern,
		2,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Move.start()


func set_generators(generators):
	if generators:
		for generator in generators:
			var g = base_generator.instance()
			var params = DBManager.get_bullet_gen(generator)
			g.set_params(params)
			$Generators.add_child(g)


# Called when the enemy takes damage
func take_damage(dmg):
	HP -= dmg
	$AnimationPlayer.play("take damage")
	if HP <= 0:
		die()


func _process(delta):
	pass


func die():
	if not exit:
		self.visible = false
		$Hitbox.disabled = true
		kill_generators()
		character.stats.enemies_killed += 1
	else:
		var spawner_instance = drop_spawner.instance()
		spawner_instance.num_drops = NUM_DROPS
		spawner_instance.stage = stage
		stage.add_child(spawner_instance)
		character.update_stats_display()
		queue_free()


func kill_generators():
	for generator in $Generators.get_children():
		generator.die()


func _on_StartMove_tween_all_completed():
	# When a tween is completed, starts generators if is not an exit tween
	if not exit:
		for generator in $Generators.get_children():
			generator.start()

	# Kills enemy if exit tween
	else:
		die()


# Enemy will exit the screen and die after a certain period of time
func _on_ExitTimer_timeout():
	kill_generators()
	run_move("exit_" + pos_override)
