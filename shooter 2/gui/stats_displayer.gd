extends VBoxContainer


func update_stats(n_bullets):
	$a.set_text("bullets on screen: "+str(n_bullets))

func _process(delta):
	$b.set_text("fps: "+str(Engine.get_frames_per_second()))
