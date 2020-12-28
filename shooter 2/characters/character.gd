extends KinematicBody2D

# Character variables
export (int) var RUN_ACC = 30
export (float) var MAX_RUN_SPEED = 2
export (float) var MAX_STRAFE_SPEED = .85
export (int) var DEF
export (float) var FIRE_RATE
export (int) var LIVES
export (int) var BOMBS

# General global variables, like thresholds and constants
export (int) var POWER_MAX
export (int) var BOMB_CHARGE_MAX
export (int) var LIFE_CHARGE_MAX
export (float) var DEATH_PENALTY
export (bool) var CAN_DIE

var RUN_SPEED = 0
var POWER = 0
var BOMB_CHARGE = 0
var LIFE_CHARGE = 0

var control = true
var mot = Vector2(0,0)
var shooting = false
var can_shoot = true
var strafing = false
var is_in_auto_zone = false
var invincible = false

signal bomb

const enemy = false
var stage

# Difficulty variables
var no_hit_time = 0
var grazed_bullets = 0

var accumulated_diff = 0
var overall_diff = 0

var shot_lv = 1

const shots = [
	preload("res://projectiles/character/shot2lv1.tscn"),
	preload("res://projectiles/character/shot2lv2.tscn"),
	preload("res://projectiles/character/shot2lv3.tscn"),
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
	
	# Sets character ship sprite/animation
	var anim = MainNodes.get_ship()
	if anim != null:
		$Sprite.play(anim)
	
	$FireRate.wait_time = FIRE_RATE
	$ShotEffect.visible = false
	$Sprite.visible = true


func update_stats_display():
	return
#	$Camera2D/GUI/Stats.update_stats(stats)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not control or LIVES == 0:
		return
#	var mouse_pos = get_global_mouse_position()
	############################# movement #####################################
	var dir = Vector2(0,0)
	var moving = false
	
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
		
	############################# shooting #####################################
	if Input.is_action_pressed("ui_left_mb") or Input.is_action_pressed("ui_spacebar"):
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
	if Input.is_action_just_pressed("ui_shift") or Input.is_action_just_pressed("ui_right_mb"):
		strafing = true
		$Hitbox/AnimationPlayer.play("ShowHitbox")
	elif strafing and not Input.is_action_pressed("ui_shift") and not Input.is_action_pressed("ui_right_mb"):
		strafing = false
		$Hitbox/AnimationPlayer.play("HideHitbox")
		
	################################### bomb ###################################
	if Input.is_action_just_pressed("ui_Q") and BOMBS > 0 and not $BombEffect/AnimationPlayer.is_playing():
		bomb()

	############################################################################
	
	if len(stage.get_node("Enemies").get_children()) > 0:
		no_hit_time += delta
	stage.stats.update_hit_free_time(no_hit_time)


func gain_drop():
	if LIVES == 0:
		return
	BOMB_CHARGE += 1 + (randf()*3)
	LIFE_CHARGE += 1 + (randf()*3)
	
	
	if shot_lv < len(shots):
		POWER += 1 + (randf()*3)
		if POWER > POWER_MAX:
			shot_lv = min(shot_lv + 1, len(shots))
			POWER = 0
	else:
		POWER = POWER_MAX
	if BOMB_CHARGE > BOMB_CHARGE_MAX:
		BOMBS += 1
		BOMB_CHARGE = 0
	if LIFE_CHARGE > LIFE_CHARGE_MAX:
		LIVES += 1
		LIFE_CHARGE = 0
	stage.stats.update_bars(self)


# Character grazed a bullet
func graze():
	if not invincible:
		grazed_bullets += 1
		$Sprite/Blink.play("Blink")


func bomb():
	BOMBS -= 1
	$BombEffect/AnimationPlayer.play("Bomb")
	$BombSound.play()
	# Emit signal to kill enemy bullets
	emit_signal("bomb")
	stage.stats.update_bars(self)


func take_damage(dmg):
	die()


func die():
	LIVES -= 1
	if not CAN_DIE:
		return
	if LIVES == 0:
		stage.game_over()
		$AnimationPlayer.play("game_over")
		$Hitbox/AnimationPlayer.play("HideHitbox")
		return
	control = false
	invincible = true
	$AnimationPlayer.play("death")
	$Sprite/Invincible.play("Invincible")
	$Invincibility.start()
	$DeathSound.play()
	
	$ShotEffect/AnimationPlayer.stop()
	$ShotEffect.set_visible(false)
	strafing = false
	$Hitbox/AnimationPlayer.play("HideHitbox")
	$Hitbox.disabled = true
	
	shot_lv = 1
	POWER = 0
	no_hit_time = 0
	
	print("shiet mang im ded")
	stage.overall_difficulty /= DEATH_PENALTY
	stage.stats.update_bars(self)
	if LIVES == 0:

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

		# queue_free()
		pass


func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		print ("You are quit!")
		action_recorder.save()


func _on_FireRate_timeout():
	can_shoot = true


func _on_DiffUpdate_timeout():
	if LIVES == 0:
		return
	stage.update_diff(no_hit_time, grazed_bullets)
	grazed_bullets = 0


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		control = true


func _on_Invincibility_timeout():
	invincible = false
	$Hitbox.disabled = false
	$Sprite/Invincible.stop()
	$Sprite.self_modulate = Color(1,1,1,1)


func goto_main_menu():
	get_tree().change_scene("res://menus/main_menu.tscn")
