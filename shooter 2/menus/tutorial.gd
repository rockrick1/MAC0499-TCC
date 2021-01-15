extends Control


var current_page = 1
const num_pages = 5


func _ready():
	$ColorRect/Pages.set_animation("1")
	$ColorRect/Num.set_text(str(current_page)+"/"+str(num_pages))


func _on_Next_pressed():
	if current_page == num_pages:
		return
	current_page += 1
	$ColorRect/Pages.set_animation(str(current_page))
	$ColorRect/Num.set_text(str(current_page)+"/"+str(num_pages))

func _on_Prev_pressed():
	if current_page == 1:
		return
	current_page -= 1
	$ColorRect/Pages.set_animation(str(current_page))
	$ColorRect/Num.set_text(str(current_page)+"/"+str(num_pages))


func _on_Close_pressed():
	queue_free()
