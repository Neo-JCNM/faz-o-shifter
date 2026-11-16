extends CharacterBody2D


class_name playerMove
#region Variables
@export_group("Physic")
@export var speed = 400;

@export_group("Data")
@export var caracteristics :  AnimalShiftSO = null;
var originalShiftDuration;
@export var baseCaracteristics :  AnimalShiftSO = null;
@export var cooldown = 5.0
var screenSize;
var fazed
signal hit;
signal move;
<<<<<<< HEAD
var timer = Timer.new();
@onready var Doors = get_tree().get_nodes_in_group("doors")
=======
>>>>>>> acae27a1e3befff0868099f3088af9c5353cda0b

#endregion


#region Main Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AlertLevel.alert_act = 0
	screenSize = get_camera_rect()
	hide();
	SceneMan.doors = Doors
	start();
	if SceneMan.first_spawn:
		print(Doors)
		position = SceneMan._update_door().global_position
	else: 
		position = Vector2.ZERO
	caracteristics = baseCaracteristics
	
	
func get_camera_rect() -> Rect2:
	var cam = get_viewport().get_camera_2d()
	var size = get_viewport_rect().size / cam.zoom
	var center = cam.get_screen_center_position()
	return Rect2(center - size / 2.0, size)

func start()-> void:
	position.clamp(screenSize.position, screenSize.end);
	show();
	$CollisionShape2D.disabled = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(caracteristics.shiftDuration)
	print(cooldown)
	cooldown -= 1 * delta
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
	position = position.clamp(screenSize.position, screenSize.end);
	if AlertLevel.is_hiding:
		visible = false
	else: 
		visible = true
	
	if(fazed):
		if(caracteristics.shiftDuration > 0):
			caracteristics.shiftDuration -= 1 * delta
		else:
			fazed = false
			caracteristics.shiftDuration = originalShiftDuration;
			caracteristics = baseCaracteristics;
			speed = caracteristics.speed;
			$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
		

func onBodyEntered(_body):
	hide();
	hit.emit();
	#$CollisionShape2D.set_deferred("disabled", true);

func _on_faz():
	speed = caracteristics.speed;
	originalShiftDuration = caracteristics.shiftDuration;
	cooldown = originalShiftDuration + 5.0
	fazed = true
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	print("Fazing succeeded ! \n");
	



#endregion
