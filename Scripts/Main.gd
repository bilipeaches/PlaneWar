extends Control

# 开始游戏
func _on_Start_pressed():
	$AnimationPlayer.play_backwards("开场动画")
	yield($AnimationPlayer, "animation_finished")
	# 切换场景
	var res = get_tree().change_scene("res://Scenes/Game.tscn")
	if res == OK:
		print("场景切换成功！")
	else:
		OS.alert("场景竟然切换失败了？？？！", "错误")

# 如何游玩
func _on_HowToPlay_pressed():
	$"遮罩/AnimationPlayer".play("遮罩")
	yield($"遮罩/AnimationPlayer", "animation_finished")
	OS.alert("""
	按住 ↑ ↓ ← → 进行飞机的移动，子弹会自动进行发射，按 Enter/Space 进行炸弹发射。
	子弹和炸弹补给会在战斗中发放，有一定间隔时间。
	祝您游戏愉快！\n\n\n
	by bilipeaches
	""", "游戏玩法")
	$"遮罩/AnimationPlayer".play_backwards("遮罩")

# 退出游戏
func _on_Quit_pressed():
	get_tree().quit()
