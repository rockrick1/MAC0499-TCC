extends Node


func get_vars(filename):
	var params = {}
	var file = File.new()
	file.open("res://db/"+filename+".json", file.READ)
	var text = file.get_as_text()
	params = parse_json(text)
	file.close()
	return params

func get_bullet_gen(name):
	return get_vars('generators/'+name)


func get_stage(name):
	return get_vars('stages/'+name)
