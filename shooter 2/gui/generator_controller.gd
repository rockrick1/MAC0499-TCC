extends VBoxContainer


var generators
var generator
var generator_n = -1
var total_generators = 0
var enemy


var current_demo = 1


const base_generator = preload("res://characters/bullet_generator.tscn")


func set_enemy(node):
	enemy = node
	generators = enemy.get_node("Generators").get_children()


func set_generator(node):
	generator = node



func _on_GeneratorDown_pressed():
	if total_generators == 0:
		return
	generator_n = max(generator_n-1,0)
	generator = generators[generator_n]
	$Buttons/Generator/Number.set_text(str(generator_n))
	update_numbers()


func _on_GeneratorUp_pressed():
	if total_generators == 0:
		return
	generator_n = min(generator_n+1,len(generators)-1)
	generator = generators[generator_n]
	$Buttons/Generator/Number.set_text(str(generator_n))
	update_numbers()


func _on_GeneratorAdd_pressed():
	var generator_n = total_generators
	total_generators += 1

	var g = base_generator.instance()
	var params = DBManager.get_bullet_gen("demo"+str(current_demo))
	current_demo += 1
	g.set_params(params, params.proj_type, 0)
	enemy.get_node("Generators").add_child(g)
	generators = enemy.get_node("Generators").get_children()
	generator = g
	g.start_on_timer()
	$Buttons/Generator/Number.set_text(str(generator_n))
	update_numbers()




func _on_LifeDown_pressed():
	generator.life -= 5
	$Buttons/Life/Number.set_text(str(generator.life))


func _on_LifeUp_pressed():
	generator.life += 5
	$Buttons/Life/Number.set_text(str(generator.life))



func _on_BulletsPerArrayDown_pressed():
	generator.bullets_per_array -= 1
	$Buttons/BulletsPerArray/Number.set_text(str(generator.bullets_per_array))


func _on_BulletsPerArrayUp_pressed():
	generator.bullets_per_array += 1
	$Buttons/BulletsPerArray/Number.set_text(str(generator.bullets_per_array))



func _on_IndividualArraySpreadDown_pressed():
	generator.individual_array_spread -= 10
	$Buttons/IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))


func _on_IndividualArraySpreadUp_pressed():
	generator.individual_array_spread += 10
	$Buttons/IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))



func _on_TotalBulletArraysDown_pressed():
	generator.total_bullet_arrays -= 1
	$Buttons/TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))


func _on_TotalBulletArraysUp_pressed():
	generator.total_bullet_arrays += 1
	$Buttons/TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))



func _on_TotalArraySpreadDown_pressed():
	generator.total_array_spread -= 10
	$Buttons/TotalArraySpread/Number.set_text(str(generator.total_array_spread))


func _on_TotalArraySpreadUp_pressed():
	generator.total_array_spread += 10
	$Buttons/TotalArraySpread/Number.set_text(str(generator.total_array_spread))



func _on_BaseSpinSpeedDown_pressed():
	generator.set_spin_speed(generator.base_spin_speed - 5, generator.mod_spin_speed)
	$Buttons/BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))


func _on_BaseSpinSpeedUp_pressed():
	generator.set_spin_speed(generator.base_spin_speed + 5, generator.mod_spin_speed)
	$Buttons/BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))


	
func _on_SpinSpeedPeriodDown_pressed():
	generator.spin_speed_period -= .5
	$Buttons/SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))
	
		
func _on_SpinSpeedPeriodUp_pressed():
	generator.spin_speed_period += .5
	$Buttons/SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))


func _on_SpinVariationDown_pressed():
	generator.spin_variation -= 5
	$Buttons/SpinVariation/Number.set_text(str(generator.spin_variation))


func _on_SpinVariationUp_pressed():
	generator.spin_variation += 5
	$Buttons/SpinVariation/Number.set_text(str(generator.spin_variation))



func _on_FireRateDown_pressed():
	if generator.fire_rate <= 1:
		var inverse = 1/generator.fire_rate
		inverse += 1
		generator.set_fire_rate(1/inverse, generator.mod_fire_rate)
	else:
		generator.set_fire_rate(generator.fire_rate - 1, generator.mod_fire_rate)
	$Buttons/FireRate/Numbers/Number1.set_text(str(generator.fire_rate))
	$Buttons/FireRate/Numbers/Number2.set_text(str(1/generator.fire_rate))


func _on_FireRateUp_pressed():
	if generator.fire_rate < 1:
		var inverse = 1/generator.fire_rate
		inverse -= 1
		generator.set_fire_rate(1/inverse, generator.mod_fire_rate)
	else:
		generator.set_fire_rate(generator.fire_rate + 1, generator.mod_fire_rate)
	$Buttons/FireRate/Numbers/Number1.set_text(str(generator.fire_rate))
	$Buttons/FireRate/Numbers/Number2.set_text(str(1/generator.fire_rate))


func _on_AimAtCharacter_toggled(button_pressed):
	generator.aim_at_character = button_pressed


func _on_CyclesPerIntervalDown_pressed():
	generator.cycles_per_interval -= 1
	$Buttons/CyclesPerInterval/Number.set_text(str(generator.cycles_per_interval))


func _on_CyclesPerIntervalUp_pressed():
	generator.cycles_per_interval += 1
	$Buttons/CyclesPerInterval/Number.set_text(str(generator.cycles_per_interval))


func _on_BulletSpeedDown_pressed():
	generator.bullet_speed -= .5
	$Buttons/BulletSpeed/Number.set_text(str(generator.bullet_speed))


func _on_BulletSpeedUp_pressed():
	generator.bullet_speed += .5
	$Buttons/BulletSpeed/Number.set_text(str(generator.bullet_speed))



func _on_BulletLifeDown_pressed():
	generator.bullet_life -= .5
	$Buttons/BulletLife/Number.set_text(str(generator.bullet_life))


func _on_BulletLifeUp_pressed():
	generator.bullet_life += .5
	$Buttons/BulletLife/Number.set_text(str(generator.bullet_life))


func update_numbers():
	$Buttons/Life/Number.set_text(str(generator.life))
	$Buttons/BulletsPerArray/Number.set_text(str(generator.bullets_per_array))
	$Buttons/IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))
	$Buttons/TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))
	$Buttons/TotalArraySpread/Number.set_text(str(generator.total_array_spread))
	$Buttons/BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))
	$Buttons/SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))
	$Buttons/SpinVariation/Number.set_text(str(generator.spin_variation))
	$Buttons/FireRate/Numbers/Number1.set_text(str(generator.fire_rate))
	$Buttons/FireRate/Numbers/Number2.set_text(str(1/generator.fire_rate))
	$Buttons/BulletSpeed/Number.set_text(str(generator.bullet_speed))
	$Buttons/BulletLife/Number.set_text(str(generator.bullet_life))
	$Buttons/AimAtCharacter/AimAtCharacter.toggle_mode = generator.aim_at_character


func _on_Export_pressed():
	var params = generator.get_params()



func _on_ZeroDiff_pressed():
	MainNodes.get_stage().overall_difficulty = 0
	MainNodes.get_character().no_hit_time = 0


func _on_Quit_pressed():
	get_tree().change_scene("res://menus/main_menu.tscn")
