extends Node

var f

func _ready():
	f = File.new()
	print(111111111)
	f.open("res://data/somefile.dat", File.WRITE)

func write_data(data):
	print(data.type + "-" + data.info)
	f.store_string(data.type + "-" + data.info + "\n")

func save():
	f.close()
