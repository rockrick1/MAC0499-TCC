extends Node2D

var enemies = {
	"blop_green": load("res://characters/blop_green.tscn"),
	"blop_blue": load("res://characters/blop_blue.tscn")
}
var enemy_names = enemies.keys()

func _on_Spawner_timeout():
	var enemy = enemies[enemy_names[randi() % enemies.size()]]
	var enemy_instance = enemy.instance()
	var r = randi() % $SpawnPositions.get_child_count() + 1
	var pos = $SpawnPositions.get_node(str(r)).get_position()
	enemy_instance.set_position(pos)
	add_child_below_node($TileMap, enemy_instance)
