extends "enemy.gd"


# for the love of god please do not connect the BossMove tween on the
# _on_Move_tween_all_completed() of the base enemy script


const move_pos = [
	48, # 7.5
	0,  # 15
	-48,# 22.5
	48, # 30
	0,  # 37.5
	0,  # 45
	0,  # 45
	0,  # 45
	0,  # 45
	0,  # 45
	0,  # 45
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
