extends Node2D


export (String) var stagename

var stage

var repeat
var waves = []

var wrs = []

var cur_wave_n = -1
var current_wave

var cur_enemy_n = -1

var spawn_complete = false

const enemy_scenes = {
	"test_enemy" : preload("res://characters/test_enemy.tscn"),
}

func _ready():
	stage = get_parent()
	parse_vars(DBManager.get_stage(stagename))


func convert_pos(pos):
	match pos:
		"right":
			return Vector2(80, -5)
		"left":
			return Vector2(-80, -5)
		"center", _:
			return Vector2(0, 0)


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
		enemy_instance.position += convert_pos(enemy.pos_override)
		enemy_instance.generator_scripts = enemy.generators
		
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

