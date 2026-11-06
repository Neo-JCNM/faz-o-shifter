extends Area2D
@export var fazable : bool = false;
@export var fazTarget : Area2D = null;

signal faz;
@export var player : playerMove = null;
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_global_mouse_position();
	if(Input.is_action_pressed("shiftButton") and (fazable) and fazTarget != null):
			print("fazing...\n");
			player.caracteristics = fazTarget.shiftData;
			faz.emit();
	


func _on_player_move(value: Vector2) -> void:
	position -= value;
	#print("compensing...\n");
	position = position.clamp(Vector2.ZERO, player.screenSize);


func _on_area_entered(area: Area2D) -> void:
	print("=== INSIDE ===\n")
	fazable = true
	if(area is Mob):
		fazTarget = area;


func _on_area_exited(area: Area2D) -> void:
	print("=== OUTSIDE ===\n")
	fazable = false
	fazTarget = null;
