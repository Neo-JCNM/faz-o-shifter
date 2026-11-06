extends Node
@onready var timer = $"./Timer"

var alert_act = 0
var aler_max = 2

func alert_up():
	alert_act = 1
	
func alert_espace():
	alert_act == 2
	timer.start()




func _on_timer_timeout() -> void:
	pass # Replace with function body.
