extends Area2D

# 速度
var speed = 100
# 宽和高
export var width = 58
export var height = 87

func _ready():
	position.y = -height
	position.x = rand_range(width / 2, 480 - width / 2)

func _physics_process(delta):
	position.y += speed * delta

func _on_Double_area_entered(area):
	if area.name == "Player":
		$Get.play()
		area.double()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bomb_area_entered(area):
	if area.name == "Player":
		$Get.play()
		if area.bombs < 3:
			area.bombs += 1
		queue_free()
