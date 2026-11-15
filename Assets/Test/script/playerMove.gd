extends CharacterBody2D


class_name playerMove
#region Variables
@export_group("Physic")
@export var speed = 400;

@export_group("Data")
@export var caracteristics :  AnimalShiftSO = null;
@export var baseCaracteristics :  AnimalShiftSO = null;
var screenSize;
var fazed
signal hit;
signal move;
var timer = Timer.new();

#endregiontyy



#region Main Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AlertLevel.alert_act = 0
	screenSize = get_viewport_rect().size;
	hide();
	start(Vector2.ZERO);
	caracteristics = baseCaracteristics
	
func start(pos)-> void:
	position = pos;
	position.clamp(Vector2.ZERO, screenSize);
	show();
	$CollisionShape2D.disabled = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2.ZERO;
	if fazed :
		print("timer", timer.time_left)
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1;
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1;
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 1;
	if Input.is_action_pressed("moveDown"):
		velocity.y += 1;
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed;
		$AnimatedSprite2D.play();
	else:
		$AnimatedSprite2D.stop();
	move.emit(velocity*delta);
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screenSize);
	if AlertLevel.is_hiding:
		visible = false
	else: 
		visible = true
		

func onBodyEntered(_body):
	hide();
	hit.emit();
	#$CollisionShape2D.set_deferred("disabled", true);

func _on_faz():
	speed = caracteristics.speed;
	fazed = true
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	print("Fazing succeeded ! \n");
	if(caracteristics.shiftDuration > 0):
		timer.wait_time = caracteristics.shiftDuration
		timer.one_shot = true
		timer.start()
	else: timer.wait_time = 0
	
func _on_timer_timeout() -> void:
	fazed = false
	caracteristics = baseCaracteristics;
	speed = caracteristics.speed;
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;



#endregion
