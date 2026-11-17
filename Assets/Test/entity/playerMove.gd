extends CharacterBody2D


class_name playerMove
#region Variables
@export_group("Physic")
@export var speed = 400;

@export_group("Data")
@export var caracteristics :  AnimalShiftSO = null;
var originalShiftDuration;
@export var baseCaracteristics :  AnimalShiftSO = null;
@export var cooldown = 5
var screenSize;
var fazed
signal hit;
signal move;
var timer = Timer.new();
var timer_cooldown = Timer.new()
var cooldown_started : bool
@onready var Doors = get_tree().get_nodes_in_group("doors")

#endregion


#region Main Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cooldown_started = false
	add_child(timer)
	add_child(timer_cooldown)
	timer_cooldown.timeout.connect(_on_timer_cooldown_timeout)
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
	if SceneMan.on_cooldown and not cooldown_started and caracteristics == baseCaracteristics:
		timer_cooldown.wait_time = cooldown
		timer_cooldown.one_shot = true
		timer_cooldown.start()
		cooldown_started = true
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
		

func onBodyEntered(_body):
	hide();
	hit.emit();
	#$CollisionShape2D.set_deferred("disabled", true);



func _on_faz():
	pass
	
func _on_timer_timeout() -> void:
	fazed = false
	SceneMan.on_cooldown = true
	caracteristics = baseCaracteristics;
	speed = caracteristics.speed;
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	
func _on_timer_cooldown_timeout() -> void:
	SceneMan.on_cooldown = false
	cooldown_started = false
	print("Off cooldown",SceneMan.on_cooldown)



#endregion


func _on_faz_oobject_faz() -> void:
	speed = caracteristics.speed;
	fazed = true
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	timer.wait_time =  15 #caracteristics.shiftDuration
	timer.one_shot = true
	timer.start()
	print("Fazing succeeded ! \n", timer.time_left);
