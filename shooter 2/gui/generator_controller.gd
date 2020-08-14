extends VBoxContainer


var generators
var generator
var generator_n = -1
var total_generators = 0
var enemy


const base_generator = preload("res://characters/bullet_generator.tscn")


func set_enemy(node):
	enemy = node
	generators = enemy.get_node("Generators").get_children()
	print(enemy)


func set_generator(node):
	generator = node



func _on_GeneratorDown_pressed():
	if total_generators == 0:
		return
	generator_n = max(generator_n-1,0)
	generator = generators[generator_n]
	$Generator/Number.set_text(str(generator_n))
	update_numbers()


func _on_GeneratorUp_pressed():
	if total_generators == 0:
		return
	generator_n = min(generator_n+1,len(generators)-1)
	generator = generators[generator_n]
	$Generator/Number.set_text(str(generator_n))
	update_numbers()


func _on_GeneratorAdd_pressed():
	var generator_n = total_generators
	total_generators += 1

	var g = base_generator.instance()
	var params = DBManager.get_bullet_gen("demo")
	g.set_params(params)
	enemy.get_node("Generators").add_child(g)
	generators = enemy.get_node("Generators").get_children()
	generator = g
	g.start()
	$Generator/Number.set_text(str(generator_n))
	update_numbers()




func _on_LifeDown_pressed():
	generator.life -= 5
	$Life/Number.set_text(str(generator.life))


func _on_LifeUp_pressed():
	generator.life += 5
	$Life/Number.set_text(str(generator.life))



func _on_BulletsPerArrayDown_pressed():
	generator.bullets_per_array -= 1
	$BulletsPerArray/Number.set_text(str(generator.bullets_per_array))


func _on_BulletsPerArrayUp_pressed():
	generator.bullets_per_array += 1
	$BulletsPerArray/Number.set_text(str(generator.bullets_per_array))



func _on_IndividualArraySpreadDown_pressed():
	generator.individual_array_spread -= 10
	$IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))


func _on_IndividualArraySpreadUp_pressed():
	generator.individual_array_spread += 10
	$IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))



func _on_TotalBulletArraysDown_pressed():
	generator.total_bullet_arrays -= 1
	$TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))


func _on_TotalBulletArraysUp_pressed():
	generator.total_bullet_arrays += 1
	$TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))



func _on_TotalArraySpreadDown_pressed():
	generator.total_array_spread -= 10
	$TotalArraySpread/Number.set_text(str(generator.total_array_spread))


func _on_TotalArraySpreadUp_pressed():
	generator.total_array_spread += 10
	$TotalArraySpread/Number.set_text(str(generator.total_array_spread))



func _on_BaseSpinSpeedDown_pressed():
	generator.set_spin_speed(generator.base_spin_speed - 5)
	$BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))


func _on_BaseSpinSpeedUp_pressed():
	generator.set_spin_speed(generator.base_spin_speed + 5)
	$BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))


	
func _on_SpinSpeedPeriodDown_pressed():
	generator.spin_speed_period -= .5
	$SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))
	
		
func _on_SpinSpeedPeriodUp_pressed():
	generator.spin_speed_period += .5
	$SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))


func _on_SpinVariationDown_pressed():
	generator.spin_variation -= 5
	$SpinVariation/Number.set_text(str(generator.spin_variation))


func _on_SpinVariationUp_pressed():
	generator.spin_variation += 5
	$SpinVariation/Number.set_text(str(generator.spin_variation))



func _on_FireRateDown_pressed():
	generator.set_fire_rate(generator.fire_rate - 1)
	$FireRate/Number.set_text(str(generator.fire_rate))


func _on_FireRateUp_pressed():
	generator.set_fire_rate(generator.fire_rate + 1)
	$FireRate/Number.set_text(str(generator.fire_rate))



func _on_FireIntervalDown_pressed():
	generator.set_fire_interval(generator.fire_interval - .25)
	$FireInterval/Number.set_text(str(generator.fire_interval))


func _on_FireIntervalUp_pressed():
	generator.set_fire_interval(generator.fire_interval + .25)
	$FireInterval/Number.set_text(str(generator.fire_interval))


func _on_CyclesPerIntervalDown_pressed():
	generator.cycles_per_interval -= 1
	$CyclesPerInterval/Number.set_text(str(generator.cycles_per_interval))


func _on_CyclesPerIntervalUp_pressed():
	generator.cycles_per_interval += 1
	$CyclesPerInterval/Number.set_text(str(generator.cycles_per_interval))


func _on_BulletSpeedDown_pressed():
	generator.bullet_speed -= .5
	$BulletSpeed/Number.set_text(str(generator.bullet_speed))


func _on_BulletSpeedUp_pressed():
	generator.bullet_speed += .5
	$BulletSpeed/Number.set_text(str(generator.bullet_speed))



func _on_BulletLifeDown_pressed():
	generator.bullet_life -= .5
	$BulletLife/Number.set_text(str(generator.bullet_life))


func _on_BulletLifeUp_pressed():
	generator.bullet_life += .5
	$BulletLife/Number.set_text(str(generator.bullet_life))


func update_numbers():
	$Life/Number.set_text(str(generator.life))
	$BulletsPerArray/Number.set_text(str(generator.bullets_per_array))
	$IndividualArraySpread/Number.set_text(str(generator.individual_array_spread))
	$TotalBulletArrays/Number.set_text(str(generator.total_bullet_arrays))
	$TotalArraySpread/Number.set_text(str(generator.total_array_spread))
	$BaseSpinSpeed/Number.set_text(str(generator.base_spin_speed))
	$SpinSpeedPeriod/Number.set_text(str(generator.spin_speed_period))
	$SpinVariation/Number.set_text(str(generator.spin_variation))
	$FireRate/Number.set_text(str(generator.fire_rate))
	$FireInterval/Number.set_text(str(generator.fire_interval))
	$BulletSpeed/Number.set_text(str(generator.bullet_speed))
	$BulletLife/Number.set_text(str(generator.bullet_life))
