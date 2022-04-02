extends Node2D

# 分数
var score = 0
# 最小\大等待时间
var min_wait_time = [
	0.2,
	1,
	2
]
var max_wait_time = [
	2,
	4,
	6
]
# 敌机
onready var small = load("res://Scenes/Enemy-Small.tscn")
onready var middle = load("res://Scenes/Enemy-Middle.tscn")
onready var large = load("res://Scenes/Enemy-Large.tscn")
# 补给
onready var double = load("res://Scenes/Double.tscn")
onready var bomb = load("res://Scenes/Bomb.tscn")

func _ready():
	randomize()
	yield($AnimationPlayer, "animation_finished")
	$Sounds/BGM.play()
	$Player.can_fly = true
	$Player/BulletAddTimer.start()
	$Background/AnimationPlayer.play("背景滚动")
	# 随机时间
	for i in 2:
		random_timer(i)
	$Timers/DoubleTimer.wait_time = rand_range(14, 20)
	$Timers/BombTimer.wait_time = rand_range(20, 25)
	for child in $Timers.get_children():
		child.start()

func _physics_process(delta):
	delta = delta
	$GUI/Score.text = "Score:" + str(score)
	$GUI/LifeNumber.text = str($Player.life)
	$GUI/BombNumber.text = "×" + str($Player.bombs)
	# 炸弹
	if Input.is_action_just_pressed("ui_accept") and $Player.bombs > 0:
		# 声音
		$Sounds/UseBomb.play()
		$Player.bombs -= 1
		for plane in $Enemies.get_children():
			plane.kill()

func random_timer(i):
	$Timers.get_children()[i].wait_time = rand_range(
		min_wait_time[i], max_wait_time[i]
	)

func _on_EnemySmallAddTimer_timeout():
	var sm = small.instance()
	$Enemies.add_child(sm)
	random_timer(0)

func _on_EnemyMiddleAddTimer_timeout():
	var md = middle.instance()
	$Enemies.add_child(md)
	random_timer(1)

func _on_EnemyLargeAddTimer_timeout():
	var lg = large.instance()
	$Enemies.add_child(lg)
	random_timer(2)

func GameOver():
	$Sounds/GameOver.play()
	$Background/AnimationPlayer.stop()
	for timer in $Timers.get_children():
		timer.stop()
	$Sounds/BGM.stop()
	$GameOver/AnimationPlayer.play("GameOver")
	$GUI/AnimationPlayer.play_backwards("Start")
	$GameOver/Panel/YourScore.text = "YourScore:" + str(score)
	var bsl = $GameOver/Panel/BestScore
	if EasySave.has_file("BestScore.data"):
		# 获取最佳成绩
		var json = EasySave.load_data_with_auto("BestScore.data")
		var bs = json["BestScore"]
		if score > bs:
			EasySave.save_data_width_auto("BestScore.data", {
				"BestScore":score
			})
			bsl.text = "BestScore:" + str(score)
		else:
			EasySave.save_data_width_auto("BestScore.data", {
			"BestScore":score
			})
			bsl.text = "BestScore:" + str(score)
	else:
		EasySave.save_data_width_auto("BestScore.data", {
			"BestScore":score
		})
		bsl.text = "BestScore:" + str(score)
	yield($GUI/AnimationPlayer, "animation_finished")
	$GUI.hide()

func _on_DoubleTimer_timeout():
	$Timers/DoubleTimer.wait_time = rand_range(14, 20)
	var db = double.instance()
	$Supply.add_child(db)
	$Timers/DoubleTimer.start()

func _on_BombTimer_timeout():
	$Timers/BombTimer.wait_time = rand_range(20, 25)
	var bm = bomb.instance()
	$Supply.add_child(bm)
	$Timers/BombTimer.start()

# 循环播放
func _on_BGM_finished():
	$Sounds/BGM.play()

func _on_Menu_pressed():
	$Background.rect_position = Vector2(0, 0)
	$GameOver/AnimationPlayer.play_backwards("GameOver")
	yield($GameOver/AnimationPlayer, "animation_finished")
	var res = get_tree().change_scene("res://Scenes/Main.tscn")
	if res != OK:
		OS.alert("场景切换失败！", "错误")

func _on_Quit_pressed():
	get_tree().quit()
