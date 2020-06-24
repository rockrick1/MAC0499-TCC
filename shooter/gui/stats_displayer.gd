extends VBoxContainer


func update_stats(params):
	var stats_displayer = $Camera2D/CanvasLayer/Stats
	if params.shots_fired != 0:
		$Accuracy.set_text("accuracy: "+str(int((params.shots_hit/params.shots_fired)*100)))
	$ShotsFired.set_text("shots fired: "+str(params.shots_fired))
	$ShotsHit.set_text("shots hit: "+str(params.shots_hit))
	$Killed.set_text("blops murdered: "+str(params.enemies_killed))
