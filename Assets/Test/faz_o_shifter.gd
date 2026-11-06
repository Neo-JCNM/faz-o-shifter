extends Area2D

signal faz;
@export var player : playerMove = null;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func onBodyStay(_body):
	if(_body.AnimalShiftSO != null):
		if(Input.is_action_pressed("shiftButton")):
			player.caracteristics = _body.AnimalShiftSO;
			faz.emit();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position();
	
