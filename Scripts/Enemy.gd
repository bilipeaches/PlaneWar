extends Area2D

# 速度
export var speed = 350
# 机身长\宽度
export var width = 64
export var height = 64
# 可得分数
export var score = 50
# 生命
export var life = 1

func _ready():
	# 调整进度条的值
	$ProgressBar.max_value = life
	$ProgressBar.value = life
	flash_life()
	# 调整位置
	position.y = -height
	position.x = rand_range(width / 2, 480 - width / 2)
	# 出场
	if "Large" in name:
		$FlyDown.play()

func _physics_process(delta):
	position.y += speed * delta

# 离开屏幕后自删
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# 碰到了
func _on_area_entered(area):
	set_deferred("monitorable", false)
	if "Bullet" in area.name:
		if $AnimatedSprite.animation != "Died":
			$AnimatedSprite.play("Hit")
		if life != 0:
			life -= 1
			flash_life()
			area.queue_free()
			if life == 0:
				$AnimatedSprite.play("Died")
				get_node("../../").score += score
				yield($AnimatedSprite, "animation_finished")
				queue_free()
	elif area.name == "Player":
		area.hit()
		life = 0
		flash_life()
		$AnimatedSprite.play("Died")
		get_node("../../").score += score
		yield($AnimatedSprite, "animation_finished")
		queue_free()

# 炸弹轰炸
func kill():
	life = 0
	flash_life()
	$AnimatedSprite.play("Died")
	yield($AnimatedSprite, "animation_finished")
	queue_free()

# 刷新进度条
func flash_life():
	var pro = $ProgressBar
	if life == 0:
		$Die.play()
		pro.value = 0
		return
	pro.value = life
	# 调整颜色
	var style = StyleBoxFlat.new()
	style.border_width_bottom = 1
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_color = Color(0.6, 0.6, 0.6)
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	if life / pro.max_value <= 0.2:
		style.bg_color = Color.red
	elif life / pro.max_value <= 0.6:
		style.bg_color = Color.yellow
	else:
		style.bg_color = Color.green
	pro.set("custom_styles/fg", style)
	set_deferred("monitorable", true)
	yield(get_tree().create_timer(0.1), "timeout")
	$AnimatedSprite.play("default")
