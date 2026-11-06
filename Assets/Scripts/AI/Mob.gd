extends Area2D

#region Main Variables
@export_group("Data")
@export var shiftData : AnimalShiftSO = null;

@export_group("Physic")
@export var speed : int = 200;
@export var velocity : Vector2 = Vector2.ZERO;

@export_group("Basic Behaviour")
@export var randomlyWandering : bool = false;

var screenSize;
var counter  = 0;


#region Test Function
func randomDirection()-> void:
	var choice = randi()%3;
	match choice:
		0 : velocity.x += 1
		1 : velocity.y += 1
		2 : velocity.x += -1
		3 : velocity.y += -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size;
	counter = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if randomlyWandering:
		#if counter >= 240:
			#counter -= 240
			#randomDirection();
		#if velocity.length() > 0:
			#velocity = velocity.normalized() * speed;
			#$AnimatedSprite2D.play();
		#else:
			#$AnimatedSprite2D.stop();
		#position += velocity * delta;
		#position = position.clamp(Vector2.ZERO, screenSize);
		#counter += randi()%20+1;
		#velocity = Vector2.ZERO;
	pass


	



func _on_area_vision_body_entered(body: Node2D) -> void:
	AlertLevel.alert_up()


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if AlertLevel.alert_act == 1:
		AlertLevel.alert_espace()
