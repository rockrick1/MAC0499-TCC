extends "enemy.gd"


const move_pos = [
	48,
	0,
	-48,
	48,
	0,
	0
]

const move_interval = 7.5
const move_time = 1
var current_pos_id = 0

func _ready():
	$MoveTimer.wait_time = move_interval

func move():
	current_pos_id += 1
	if current_pos_id >= len(move_pos):
		current_pos_id = 0
	var current_pos = move_pos[current_pos_id]
	
	$BossMove.interpolate_property(self, "position:x",
		self.position.x,
		current_pos,
		move_time,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$BossMove.start()

func _on_MoveTimer_timeout():
	move()


func _on_Move_tween_completed(object, key):
	pass # Replace with function body.
