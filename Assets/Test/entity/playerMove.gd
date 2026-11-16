extends CharacterBody2D


class_name playerMove
#region Variables
@export_group("Physic")
@export var speed = 400;

@export_group("Data")
@export var caracteristics :  AnimalShiftSO = null;
var shiftCount;
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

func _physics_process(delta: float) -> void:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(caracteristics.shiftDuration)
	if SceneMan.on_cooldown and not cooldown_started:
		timer_cooldown.wait_time = cooldown
		timer_cooldown.one_shot = true
		timer_cooldown.start()
		cooldown_started = true
	print(cooldown)
	cooldown -= 1 * delta
	if AlertLevel.is_hiding:
		visible = false
	else: 
		visible = true
	if(fazed):
		if(shiftCount > 0):
			shiftCount -= 1 * delta
		else:
			fazed = false
			caracteristics = baseCaracteristics;
			speed = caracteristics.speed;
			$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
			
	# Called every frame. 'delta' is the elapsed time since the previous frame.

func onBodyEntered(_body):
	hide();
	hit.emit();
	#$CollisionShape2D.set_deferred("disabled", true);

func _on_faz():
	if (caracteristics.collider != null):
		$CollisionShape2D.shape = caracteristics.collider
	speed = caracteristics.speed;
	shiftCount = caracteristics.shiftDuration;
	cooldown = shiftCount + 5.0
	fazed = true
	$AnimatedSprite2D.sprite_frames = caracteristics.sprite;
	print("Fazing succeeded ! \n");
	if not SceneMan.on_cooldown:
		timer.wait_time = caracteristics.shiftDuration
		timer.one_shot = true
		timer.start()
	else: timer.wait_time = 0
	
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
