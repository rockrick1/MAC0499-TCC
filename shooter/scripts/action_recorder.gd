extends Node

var f

var walk_points
var fire_points
var hit_points

func _ready():
	f = File.new()
	f.open("res://data/somefile.dat", File.WRITE)

func write_data(data):
	f.store_string(data.type + "-" + data.info + "\n")

func save():
	f.close()
