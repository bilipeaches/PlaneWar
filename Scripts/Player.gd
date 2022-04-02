extends Area2D

# 每次移动的量
var player = Vector2(0, 0)
# 速度
export var speed = 200
# 能否飞行
var can_fly = false
# 子弹
var bullet = load("res://Scenes/Bullet.tscn")
# 生命
var life = 3
# 炸弹
var bombs = 3
# 双子弹
var double = false

# warning-ignore:function_conflicts_variable
func double():
	double = true
	$DoubleTimer.start()

# 循环
func _physics_process(delta):
	if can_fly:
		var up = Input.is_action_pressed("ui_up")
		var down = Input.is_action_pressed("ui_down")
		var left = Input.is_action_pressed("ui_left")
		var right = Input.is_action_pressed("ui_right")
		if up:
			player.y -= 1
		elif down:
			player.y += 1
		else:
			player.y = 0
		if left:
			player.x -= 1
		elif right:
			player.x += 1
		else:
			player.x = 0
		position += player.normalized() * speed * delta
		position.x = clamp(position.x, 55, 480 - 55)
		position.y = clamp(position.y, 64, 852 - 32)

# 发射子弹
func _on_BulletAddTimer_timeout():
	# 声音
	$Sounds/Bullet.play()
	# 实例化节点
	if double:
		var bt = bullet.instance()
		bt.position.x = position.x - 25
		bt.position.y = position.y - 32
		get_node("../Bullets").add_child(bt)
		bt.double()
		var bt_ = bullet.instance()
		bt_.position.x = position.x + 25
		bt_.position.y = position.y - 32
		get_node("../Bullets").add_child(bt_)
		bt_.double()
	else:
		var bt = bullet.instance()
		bt.position.x = position.x
		bt.position.y = position.y - 32
		get_node("../Bullets").add_child(bt)

# 被打到
func hit():
	set_deferred("monitorable", false)
	life -= 1
	if life == 0:
		hide()
		set_deferred("monitoring", false)
		set_physics_process(false)
		$BulletAddTimer.stop()
		get_node("../").GameOver()
		return
	$AnimationPlayer.play("Hit")
	yield($AnimationPlayer, "animation_finished")
	set_deferred("monitorable", true)

# 双子弹结束
func _on_DoubleTimer_timeout():
	double = false
