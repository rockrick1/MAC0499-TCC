extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$HBoxContainer/VBoxContainer/Ship1/Frame.visible = false
	$HBoxContainer/VBoxContainer/Ship2/Frame.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ship1_pressed():
	MainNodes.set_ship("cruiser2")
	get_tree().change_scene("res://stages/test_stage.tscn")


func _on_Ship2_pressed():
	MainNodes.set_ship("biomech1")
	get_tree().change_scene("res://stages/test_stage.tscn")


func _on_Ship1_mouse_entered():
	$HBoxContainer/VBoxContainer/Ship1/Frame.visible = true


func _on_Ship1_mouse_exited():
	$HBoxContainer/VBoxContainer/Ship1/Frame.visible = false


func _on_Ship2_mouse_entered():
	$HBoxContainer/VBoxContainer/Ship2/Frame.visible = true


func _on_Ship2_mouse_exited():
	$HBoxContainer/VBoxContainer/Ship2/Frame.visible = false
