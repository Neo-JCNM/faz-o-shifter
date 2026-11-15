extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AlertLevel.is_hiding = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is playerMove and not AlertLevel.alert_act == 1:
		AlertLevel.is_hiding = true
		print("===HIDEN===")



func _on_body_exited(body: Node2D) -> void:
	if body is playerMove:
		AlertLevel.is_hiding = false
