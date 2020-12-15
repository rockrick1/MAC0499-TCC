extends VBoxContainer


func update_bullets(n_bullets):
	$a.set_text("bullets on screen: "+str(n_bullets))


func update_wave(wave):
	$b.set_text("wave: "+str(wave))


func _process(delta):
	$c.set_text("fps: "+str(Engine.get_frames_per_second()))


func update_lives(lives):
	$d2.set_text("lives: "+str(lives))


func update_diff(acc_diff, overall_diff):
	$e.set_text("acc diff: "+str(acc_diff))
	$f.set_text("overall diff: "+str(floor(overall_diff)))


func update_hit_free_time(time):
	$d.set_text("time without hits: "+str(time))


func update_power(power):
	$g.set_text("power: "+str(power))


func set_debug_1(msg):
	$h.set_text(str(msg))


func update_bars(character):
	$LivesBar.set_max(character.LIFE_CHARGE_MAX)
	$PowerBar.set_max(character.POWER_MAX)
	$BombsBar.set_max(character.BOMB_CHARGE_MAX)

	$LivesBar.value = character.LIFE_CHARGE
	$LivesLabel.set_text('Lives: '+str(character.LIVES))

	$PowerBar.value = character.POWER
	$PowerLabel.set_text('Power: '+str(character.shot_lv))

	$BombsBar.value = character.BOMB_CHARGE
	$BombsLabel.set_text('Bombs: '+str(character.BOMBS))
