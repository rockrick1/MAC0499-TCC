extends Node2D


export (String) var stagename

var stage

var repeat
var waves = []

var wrs = []

const starting_h = -75

var cur_wave_n = -1
var current_wave

var cur_enemy_n = -1

var spawn_complete = false

const enemy_scenes = {
	"test_enemy" : preload("res://characters/enemies/test_enemy.tscn"),
	"simple_enemy" : preload("res://characters/enemies/simple_enemy.tscn"),
	"void1" : preload("res://characters/enemies/void1.tscn"),
	"void2" : preload("res://characters/enemies/void2.tscn"),
	"void3" : preload("res://characters/enemies/void3.tscn"),
	"void4" : preload("res://characters/enemies/void4.tscn"),
}

func _ready():
	stage = get_parent()
	parse_vars(DBManager.get_stage(stagename))


func convert_pos(pos):
	match pos:
		"r1":
			return 20
		"r2":
			return 50
		"r3":
			return 80
		
		"l1":
			return -20
		"l2":
			return -50
		"l3":
			return -80
		
		"v1":
			return 40
		"v2":
			return 50
		"v3":
			return 60
		"v4":
			return 70
		
		"center", _:
			return 0


func parse_vars(params):
	repeat = params.repeat
	waves = params.waves


func start_next_wave():
	spawn_complete = false
	if (repeat and cur_wave_n == len(waves) - 1):
		cur_wave_n = 0
	else:
		cur_wave_n += 1
	
	stage.stats.update_wave(cur_wave_n+1)
	
	current_wave = waves[cur_wave_n]
	$EnemySpawnTimer.wait_time = waves[cur_wave_n].enemy_spawn_delay
	$EnemySpawnTimer.start()


func spawn_next_enemy():
	if current_wave.has("enemies") and cur_enemy_n < len(current_wave.enemies) - 1:
		cur_enemy_n += 1
	else: # No more enemies to spawn
		cur_enemy_n = -1
		spawn_complete = true
		return
	
	var enemy = current_wave.enemies[cur_enemy_n]
	if enemy_scenes[enemy.name]:
		var enemy_instance = enemy_scenes[enemy.name].instance()
		
		# Set enemy variables
		enemy_instance.position.y = starting_h
		enemy_instance.position.x += convert_pos(enemy.pos_h_override)
		enemy_instance.where_to_move = convert_pos(enemy.pos_v_override)
		enemy_instance.generator_scripts = enemy.generators
		enemy_instance.pos_h_override = enemy.pos_h_override
		enemy_instance.exit_time = enemy.exit_time
		
		wrs.append(weakref(enemy_instance))
		
		stage.get_node("Enemies").add_child(enemy_instance)


func _on_WaveTimer_timeout():
	pass


func _process(delta):
	if spawn_complete:
		for wr in wrs:
			if wr.get_ref():
				return
		wrs = []
		print("morreu tudo!")
		start_next_wave()


func _on_EnemySpawnTimer_timeout():
	if not spawn_complete:
		spawn_next_enemy()
		$EnemySpawnTimer.start()

