extends Node


func get_vars(filename):
	var params = {}
	var file = File.new()
	file.open("res://db/"+filename+".json", file.READ)
	print("res://db/"+filename)
	var text = file.get_as_text()
	print(text)
	params = parse_json(text)
	file.close()
	return params
