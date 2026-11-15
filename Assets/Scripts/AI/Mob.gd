extends CharacterBody2D

class_name Mob
#region Main Variables
@export var patrol : PathFollow2D 

@export_group("Data")
@export var shiftData : AnimalShiftSO = null;

@export_group("Physic")
@export var speed : int = 100;
@export var rotation_speed : int = 5


@export_group("Basic Behaviour")
@export var randomlyWandering : bool = false;
@onready var player = get_tree().get_first_node_in_group("player")


var screenSize;
var counter  = 0;
var last_post: Vector2
var return_pat
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
	AlertLevel.alert_act = 0
	screenSize = get_viewport_rect().size;
	counter = 0;
	patrol.rotates = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction
	var rotation_direction
	if AlertLevel.alert_act == 0:
		if return_pat:
			direction = patrol.global_position
			if global_position.distance_to(direction) > 5.0:
				velocity = global_position.direction_to(direction) * 100
			else:
				return_pat = false
		else:
			patrol.progress += 100 * delta
			direction = patrol.global_position
			velocity = (direction - global_position) / delta
		move_and_slide()
		rotation_direction = (global_position - last_post).angle() - PI/2
		rotation = lerp_angle(rotation, rotation_direction, 25 * delta)
		last_post = global_position
	else:
		return_pat = true
		if not is_instance_valid(player):
			player = get_tree().get_first_node_in_group("player")
		if is_instance_valid(player):
			direction = global_position.direction_to(player.global_position)
			velocity = direction * 100
			rotation_direction =direction.angle() - PI/2
			rotation = lerp_angle(rotation, rotation_direction, 0.1)
			move_and_collide(velocity * delta)

func _on_area_vision_body_entered(body: Node2D) -> void:
	if not player.caracteristics == shiftData and body is playerMove and not AlertLevel.is_hiding:
		AlertLevel.alert_up()


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if AlertLevel.alert_act == 1:
		AlertLevel.alert_espace()
		
