extends VBoxContainer


func update_bullets(n_bullets):
	$a.set_text("bullets on screen: "+str(n_bullets))


func update_wave(wave):
	$b.set_text("wave: "+str(wave))


func _process(delta):
	$c.set_text("fps: "+str(Engine.get_frames_per_second()))


func update_difficulty(diff,vec):
	$e.set_text("overall difficulty: "+str(diff) + " " + str(vec))


func update_hit_free_time(time):
	$d.set_text("time without hits: "+str(time))
