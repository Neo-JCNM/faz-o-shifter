extends CharacterBody2D


class_name playerMove
#region Variables
@export_group("Physic")
@export var speed = 400;

@export_group("Data")
@export var caracteristics :  AnimalShiftSO = null;
@export var baseCaracteristics :  AnimalShiftSO = null;
@export var timer : Timer = null;

var screenSize;
signal hit;
signal move;

#endregiontyy



#region Main Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	
	print("timer = ",timer.wait_time)
	velocity = Vector2.ZERO;
	
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
	
func onBodyEntered(_body):
	hide();
	hit.emit();
	#$CollisionShape2D.set_deferred("disabled", true);

func _on_faz():
	speed = caracteristics.speed;
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	print("Fazing succeeded ! \n");
	if(caracteristics.shiftDuration > 0):
		timer.start(caracteristics.shiftDuration)
	else: timer.wait_time = 0
	
func _on_timer_timeout() -> void:
	caracteristics = baseCaracteristics;
	speed = caracteristics.speed;
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;



#endregion
