extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = AlertLevel.timer.wait_time
	indeterminate = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if AlertLevel.alert_act == 1:
		value = max_value
		indeterminate = true
	if AlertLevel.alert_act == 2:
		indeterminate = false
		value = AlertLevel.timer.time_left
