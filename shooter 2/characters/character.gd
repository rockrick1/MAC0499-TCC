extends KinematicBody2D

export (int) var RUN_ACC = 30
export (int) var MAX_RUN_SPEED = 2
export (float) var MAX_HP
export (int) var DEF
export (float) var FIRE_RATE

var RUN_SPEED = 0
var HP

var mot = Vector2(0,0)
var shooting = false
var can_shoot = true

const enemy = false
var arena

const shot = preload("res://projectiles/shot1.tscn")

#const pistol = preload("res://guns/pistol.tscn")
#const machinegun = preload("res://guns/machinegun.tscn")
#
#var guns = [pistol, machinegun]
#var gun_names = ["Pistol", "Machinegun"]
#var cur_gun = 1
#var cur_gun_name = gun_names[cur_gun]
#
#var mouse_vec
#var mouse_angle

########################### action recording ###################################
const ActionRecorder = preload("res://scripts/action_recorder.gd")
onready var action_recorder = ActionRecorder.new()

var stats = {
	"shots_fired": 0.0,
	"shots_hit": 0.0,
	"enemies_killed": 0
}


################################################################################
# Called when the node enters the scene tree for the first time.
func _ready():
	arena = get_parent()
	action_recorder._ready()
	HP = MAX_HP
	$FireRate.wait_time = FIRE_RATE
#	$Camera2D/GUI/HealthBar.max_value = MAX_HP
#	$Camera2D/GUI/HealthBar.value = HP


func update_stats_display():
	return
	$Camera2D/GUI/Stats.update_stats(stats)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var pos = get_position()
#	mouse_vec = (mouse_pos - pos).normalized() * 6
#	mouse_angle = rad2deg(mouse_vec.angle())
	
	# Adjusts gun position
#	adjust_gun_pos()
	
	# Flips character sprite
#	if mouse_pos.x < pos.x: # faces left
#		$Sprite.set_flip_h(true)
#	else: # faces right
#		$Sprite.set_flip_h(false)
	############################# movement #####################################
	var dir = Vector2(0,0)
	var moving = false
	
	var data = {"type" : "movement", "info" : ""}
	if Input.is_action_pressed("ui_left"):
		moving = true
		dir.x -= 1
		data.info = "Left"
		action_recorder.write_data(data)
	elif Input.is_action_pressed("ui_right"):
		moving = true
		dir.x += 1
		data.info = "Right"
		action_recorder.write_data(data)
	if Input.is_action_pressed("ui_down"):
		moving = true
		dir.y += 1
		data.info += "Down"
		action_recorder.write_data(data)
	elif Input.is_action_pressed("ui_up"):
		moving = true
		dir.y -= 1
		data.info += "Up"
		action_recorder.write_data(data)
	
	if moving:
#		$Sprite.set_animation("run")
		RUN_SPEED = min(MAX_RUN_SPEED, RUN_SPEED + (RUN_ACC * delta))
		mot = dir.normalized()*RUN_SPEED
	else:
		RUN_SPEED = max(0, RUN_SPEED - (RUN_ACC * delta))
		mot = mot.normalized()*RUN_SPEED
	if delta != 0:
#		if mot == Vector2(0, 0):
#			$Sprite.set_animation("idle")
		move_and_slide(mot / delta)
	############################################################################
	
	############################# shooting #####################################
	if Input.is_action_pressed("ui_action") or Input.is_action_pressed("ui_select"):
		$AnimationPlayer.play("Shooting")
		if can_shoot:
			can_shoot = false
			$FireRate.start()
			var shot_instance = shot.instance()
			shot_instance.position = $ShotOrigin.get_global_position()
			shot_instance.shooter = self
			shot_instance.set_direction(Vector2(0,-1))
			arena.add_child_below_node(self, shot_instance)
			
		
		shooting = true
	elif shooting:
		$AnimationPlayer.stop()
		$ShotEffect.set_visible(false)
		shooting = false


func take_damage(dmg):
	HP -= dmg
#	$AnimationPlayer.play("take damage")
#	$Particles2D.restart()
	if HP <= 0:
		die()
		
#	$Camera2D/GUI/HealthBar.value = HP


func die():
	print("shiet mang im ded")
	return
	action_recorder.save()
	queue_free()
	get_parent().queue_free()


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print ("You are quit!")
		action_recorder.save()


func _on_FireRate_timeout():
	can_shoot = true
