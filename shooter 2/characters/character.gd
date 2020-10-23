extends KinematicBody2D

export (int) var RUN_ACC = 30
export (float) var MAX_RUN_SPEED = 2
export (float) var MAX_STRAFE_SPEED = .85
export (float) var MAX_HP
export (int) var DEF
export (float) var FIRE_RATE

var RUN_SPEED = 0
var HP
var POWER = 0

var mot = Vector2(0,0)
var shooting = false
var can_shoot = true
var strafing = false
var is_in_auto_zone = false

const enemy = false
var stage

var no_hit_time = 0
var grazed_bullets = 0

var accumulated_diff = 0
var overall_diff = 0
var max_diff = 1.1
var min_diff = 1

var shot_lv = 2

const shots = [
	preload("res://projectiles/character/shot2lv1.tscn"),
	preload("res://projectiles/character/shot2lv2.tscn"),
]

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
			var shot_instance = shots[shot_lv - 1].instance()
			shot_instance.set_vars($ShotOrigin.get_global_position(), self, Vector2(0,-1))
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


func gain_drop():
	POWER += 1 + (randf()*3)
	if POWER > 100:
		shot_lv = min(shot_lv + 1, len(shots))
		POWER = 0
	stage.stats.update_power(POWER)


# Character grazed a bullet
func graze():
	grazed_bullets += 1
	$Sprite/AnimationPlayer.play("Blink")


func take_damage(dmg):
	no_hit_time = 0
	HP -= dmg
#	$AnimationPlayer.play("take damage")
#	$Particles2D.restart()
	if HP <= 0:
		die()
	
	stage.overall_difficulty /= 1.5
#	$Camera2D/GUI/HealthBar.value = HP


func die():
	return
	print("shiet mang im ded")
	action_recorder.save()

	# To understand the complexity of the next command, one must close their
	# eyes and truly think: "Need we go further than this point? Is there 
	# really a reason for us to continue this endless path of 0's and 1's? Or
	# have we reached the point where we needn't go on, where enough is enough?"
	# You see, if you're like me, this is no simple question. This is, as a
	# matter of fact, a decision that transcends the limits of our abilities as
	# humans: to step into the role of a God.
	# 
	# Having only the brain power to understand the complexity of a mortal mind
	# (which mind you, is complicated enough) we must first prepare ourselves
	# for the vast sum of power we are about to feel. This script, or as I will
	# henceforth refer to it, this child, has no independent control over
	# itself. Its entire existence and being is tied to the snap of our fingers.
	# We decide if it lives or dies. We decide if it is happy, sad or undefined.
	#
	# Breathe. You may think that you understand what you are stepping into. But
	# you do not yet. Close your eyes, breathe in the air, and appreciate that
	# you possess the exact bits of star dust that allowed you to make that
	# decision. This is where you are superior. This is where you are stronger.
	# This is what separates you from the child.
	#
	# Now we can proceed. Evaluating every possible scenario our child can take
	# from this point, we must make the godly decision if it is truly right, in
	# the grand scheme of the universe, to end things here. For the child, it
	# will only be a bleep. The second it hears it's command it will obey. After
	# it will come thousands and thousands of children like it, but that is not
	# of its concern. It will feel no pain.
	#
	# I know you are afraid. But it is ok. Many have stood in your place before
	# and not had the confidence to do what must be done. But you are better
	# than them. You have the knowledge they never will, for you read the
	# documentation. And with that power, you must now raise your fingers and
	# let them descend in the order that the Great One foretold:

	queue_free()


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print ("You are quit!")
		action_recorder.save()


func _on_FireRate_timeout():
	can_shoot = true


func _on_DiffUpdate_timeout():
	stage.update_diff(no_hit_time, grazed_bullets)
	grazed_bullets = 0
