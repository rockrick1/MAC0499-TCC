extends Node2D


export (Dictionary) var speeds = {
	"Fast" : 230,
	"Normal" : 200,
	"Slow" : 170
}


func update_diff(diff):
	for emitter in get_children():
		var base_speed = speeds[emitter.name]
		var speed = base_speed * (log(diff) / log(10))
		if speed <= base_speed:
			speed = base_speed
		emitter.get_process_material().initial_velocity = speed
