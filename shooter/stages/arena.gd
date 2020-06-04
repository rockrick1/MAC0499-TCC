extends Node2D
var enemy_scene = load("res://characters/enemy.tscn")

func _on_Spawner_timeout():
	var enemy_instance = enemy_scene.instance()
	var r = randi() % $Spawner.get_child_count() + 1
	var pos = $Spawner.get_node(str(r)).get_position()
	enemy_instance.set_position(pos)
	add_child_below_node($TileMap, enemy_instance)
