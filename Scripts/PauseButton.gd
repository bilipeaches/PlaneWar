extends TextureButton

# 图片
onready var pause = load("res://Assets/Images/pause.png")
onready var pause_2 = load("res://Assets/Images/pause_2.png")
onready var start = load("res://Assets/Images/start.png")
onready var start_2 = load("res://Assets/Images/start_2.png")

func _on_PauseButton_pressed():
	if get_tree().paused:
		texture_normal = pause
		texture_hover = pause_2
		get_tree().paused = false
	else:
		texture_normal = start
		texture_hover = start_2
		get_tree().paused = true
