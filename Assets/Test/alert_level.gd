extends Node

var timer = Timer.new()


@onready var alert_act = 0

func _ready():
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
func alert_up():
	alert_act = 1
	print("===ALERT===")
	
func alert_espace():
	alert_act = 2
	print("===ESCAPE===")
	timer.wait_time = 3
	timer.one_shot = true
	timer.start()

func _on_timer_timeout() -> void:
	alert_act = 0
	print("===LOST===")
