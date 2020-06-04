extends KinematicBody2D

var MAX_RUN_SPEED = 2
var RUN_SPEED = 0
var RUN_ACC = 20
var mot = Vector2(0,0)

var pistol = preload("res://guns/pistol.tscn")
var machinegun = preload("res://guns/machinegun.tscn")

var guns = [pistol, machinegun]
var gun_names = ["Pistol", "Machinegun"]
var cur_gun = 1
var cur_gun_name = gun_names[cur_gun]

var mouse_vec
var mouse_angle

# Called when the node enters the scene tree for the first time.
func _ready():
	change_gun(cur_gun)

func prev_gun():
	if cur_gun == 0:
		change_gun(len(guns) - 1)
		return
	change_gun(cur_gun - 1)

func next_gun():
	change_gun((cur_gun + 1) % len(guns))

func change_gun(gun_idx):
	if get_node(cur_gun_name):
		get_node(cur_gun_name).queue_free()
	cur_gun = gun_idx
	cur_gun_name = gun_names[cur_gun]
	var gun_scene = guns[gun_idx]
	var gun_inst = gun_scene.instance()
	print(gun_inst.name)
	add_child(gun_inst)
	# When running this function prom _ready(), we dont have the mouse variables
	# yet, so...
	if mouse_vec and mouse_angle:
		adjust_gun_pos()
	
func adjust_gun_pos():
	if get_node(cur_gun_name):
		get_node(cur_gun_name).set_position(mouse_vec)
		if mouse_angle > 90 or mouse_angle < -90:
			get_node(cur_gun_name).flip_v(true)
		else:
			get_node(cur_gun_name).flip_v(false)
		get_node(cur_gun_name).set_rotation(mouse_vec.angle())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var pos = get_position()
	mouse_vec = (mouse_pos - pos).normalized() * 6
	mouse_angle = rad2deg(mouse_vec.angle())
	
	# Adjusts gun position
	adjust_gun_pos()
	
	# Flips character sprite
	if mouse_pos.x < pos.x: # faces left
		$Sprite.set_flip_h(true)
	else: # faces right
		$Sprite.set_flip_h(false)
		
	var dir = Vector2(0,0)
	var moving = false
	
	if Input.is_action_pressed("ui_left"):
		moving = true
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		moving = true
		dir.x += 1
	if Input.is_action_pressed("ui_down"):
		moving = true
		dir.y += 1
	if Input.is_action_pressed("ui_up"):
		moving = true
		dir.y -= 1
	
	if moving:
		$Sprite.set_animation("run")
		RUN_SPEED = min(MAX_RUN_SPEED, RUN_SPEED + (RUN_ACC * delta))
		mot = dir.normalized()*RUN_SPEED
	else:
		RUN_SPEED = max(0, RUN_SPEED - (RUN_ACC * delta))
		mot = mot.normalized()*RUN_SPEED
	if delta != 0:
		if mot == Vector2(0, 0):
			$Sprite.set_animation("idle")
		move_and_slide(mot / delta)
	
	if Input.is_action_pressed("ui_action") and get_node(cur_gun_name):
		get_node(cur_gun_name).shoot(mouse_vec.normalized())
	
	if Input.is_action_just_pressed("ui_prev"):
		print(12)
		prev_gun()
	if Input.is_action_just_pressed("ui_next"):
		print(999)
		next_gun()
