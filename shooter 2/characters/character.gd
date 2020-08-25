extends KinematicBody2D

export (int) var RUN_ACC = 30
export (float) var MAX_RUN_SPEED = 2
export (float) var MAX_STRAFE_SPEED = .85
export (float) var MAX_HP
export (int) var DEF
export (float) var FIRE_RATE

var RUN_SPEED = 0
var HP

var mot = Vector2(0,0)
var shooting = false
var can_shoot = true
var strafing = false

const enemy = false
var stage

var no_hit_time = 0

var accumulated_diff = 0
var max_diff = 1.1
var min_diff = 1

const shot = preload("res://projectiles/shot1.tscn")

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
	stage = get_parent()
	action_recorder._ready()
	HP = MAX_HP
	$FireRate.wait_time = FIRE_RATE
	$ShotEffect.visible = false
#	$Camera2D/GUI/HealthBar.max_value = MAX_HP
#	$Camera2D/GUI/HealthBar.value = HP


func update_stats_display():
	return
#	$Camera2D/GUI/Stats.update_stats(stats)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var mouse_pos = get_global_mouse_position()
	############################# movement #####################################
	var dir = Vector2(0,0)
	var moving = false
	
	# var data = {"type" : "movement", "info" : ""}
	if Input.is_action_pressed("ui_left"):
		moving = true
		dir.x -= 1
		# data.info = "Left"
#		action_recorder.write_data(data)
	elif Input.is_action_pressed("ui_right"):
		moving = true
		dir.x += 1
		# data.info = "Right"
#		action_recorder.write_data(data)
	if Input.is_action_pressed("ui_down"):
		moving = true
		dir.y += 1
		# data.info += "Down"
#		action_recorder.write_data(data)
	elif Input.is_action_pressed("ui_up"):
		moving = true
		dir.y -= 1
		# data.info += "Up"
#		action_recorder.write_data(data)
	
	if moving:
		if strafing:
			RUN_SPEED = min(MAX_STRAFE_SPEED, RUN_SPEED + (RUN_ACC * delta))	
		else:
			RUN_SPEED = min(MAX_RUN_SPEED, RUN_SPEED + (RUN_ACC * delta))
		mot = dir.normalized()*RUN_SPEED
	else:
		RUN_SPEED = max(0, RUN_SPEED - (RUN_ACC * delta))
		mot = mot.normalized()*RUN_SPEED
	if delta != 0:
		move_and_slide(mot / delta)
	############################################################################
	
	############################# shooting #####################################
	if Input.is_action_pressed("ui_action") or Input.is_action_pressed("ui_select"):
		$ShotEffect/AnimationPlayer.play("Shooting")
		if can_shoot:
			can_shoot = false
			$FireRate.start()
			var shot_instance = shot.instance()
			shot_instance.position = $ShotOrigin.get_global_position()
			shot_instance.shooter = self
			shot_instance.set_direction(Vector2(0,-1))
			stage.add_child_below_node(self, shot_instance)
			
		
		shooting = true
	elif shooting:
		$ShotEffect/AnimationPlayer.stop()
		$ShotEffect.set_visible(false)
		shooting = false
	
	################################## strafe ##################################
	if Input.is_action_just_pressed("ui_secondary_action"):
		strafing = true
		$Hitbox/AnimationPlayer.play("ShowHitbox")
	elif Input.is_action_just_released("ui_secondary_action"):
		strafing = false
		$Hitbox/AnimationPlayer.play("HideHitbox")
	############################################################################
	
	if len(stage.get_node("Enemies").get_children()) > 0:
		no_hit_time += delta
	stage.stats.update_hit_free_time(no_hit_time)
	
	calculate_difficulty()


func take_damage(dmg):
	no_hit_time = 0
	HP -= dmg
#	$AnimationPlayer.play("take damage")
#	$Particles2D.restart()
	if HP <= 0:
		die()
		
#	$Camera2D/GUI/HealthBar.value = HP


func calculate_difficulty():
	var a = 1
	var b = 10
	if accumulated_diff > max_diff:
		max_diff = accumulated_diff
	if accumulated_diff < min_diff:
		min_diff = accumulated_diff
	
	var current_diff = accumulated_diff
	
	var core_action_points = 0
	
	var no_hit_points = 0
	
	# Points gained from not getting hit, considering time and amount of
	# bullets on screen
	no_hit_points = pow((pow(no_hit_time, 1.1) * stage.n_bullets) / 500, 1)
	
	accumulated_diff = floor(no_hit_points / 2)
	
	stage.stats.update_difficulty(accumulated_diff)


func die():
	return
	print("shiet mang im ded")
	action_recorder.save()
	queue_free()
	get_parent().queue_free()


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print ("You are quit!")
		action_recorder.save()


func _on_FireRate_timeout():
	can_shoot = true

