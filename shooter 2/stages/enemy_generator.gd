extends Node2D


export (String) var stagename

var stage

var repeat
var waves = []

var current_wave_num = -1
var current_wave

const enemy_scenes = {
	"test_enemy" : preload("res://characters/test_enemy.tscn"),
}

func _ready():
	stage = MainNodes.get_stage()
	parse_vars(DBManager.get_stage(stagename))


func parse_vars(params):
	repeat = params.repeat
	waves = params.waves
	start_next_wave()


func start_next_wave():
	current_wave_num += 1
	current_wave = waves[current_wave_num]
	$WaveTimer.wait_time = current_wave.delay
	for enemy in current_wave.enemies:
		print(enemy)
		print(enemy.name)
		print(enemy.pos_override)
#		spawn_enemy(enemy_name)
	$WaveTimer.start()


func spawn_enemy(name):
	var enemy_instance = enemy_scenes[name].instance()
	stage.get_node("Enemies").add_child(enemy_instance)


func _on_WaveTimer_timeout():
	pass


func _process(delta):
	pass


