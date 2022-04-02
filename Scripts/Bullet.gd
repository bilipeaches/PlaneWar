extends Area2D

# 速度
export var speed = 350
# 超级子弹
onready var bullet_2 = load("res://Assets/Images/missile_2.png")

func double():
	$Sprite.texture = bullet_2

func _physics_process(delta):
	position.y -= speed * delta

# 离开场景自删
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
