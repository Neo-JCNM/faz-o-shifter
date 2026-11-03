extends Area2D
#region Variables
@export_group("Physic")
@export var speed = 400;
@export var velocity = Vector2.ZERO;
var screenSize;
signal hit;
#endregion

#region Main Functions
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size;
	hide();
	start(Vector2.ZERO)
	
func start(pos)-> void:
	position = pos;
	position.clamp(Vector2.ZERO, screenSize);
	show();
	$CollisionShape2D.disabled = false;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
	
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screenSize);
	
func onBodyEntered(_body):
	hide();
	hit.emit();
	$CollisionShape2D.set_deferred("disabled", true);
	
	
#endregion
