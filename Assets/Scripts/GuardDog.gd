extends Mob
class_name GuardDog

enum DogState {
	PATROL,
	TRACKING,
	BARKING,
	CHASING
}

@export var tracking_speed: int = 130
@export var chase_speed: int = 280

var current_state: DogState = DogState.PATROL
var player_in_smell_range: bool = false
var player_in_vision: bool = false

@onready var bark_timer: Timer = $BarkTimer
@onready var bark_sound: AudioStreamPlayer2D = $BarkSound

func _ready() -> void:
	super._ready()
	bark_timer.wait_time = 2.0
	bark_timer.one_shot = true
	bark_timer.timeout.connect(_on_bark_timer_timeout)

func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		return

	_evaluate_state_transitions()

	match current_state:
		DogState.PATROL:
			super.execute_base_ai(delta)
			
		DogState.TRACKING:
			_move_towards_player(tracking_speed, delta)
			
		DogState.BARKING:
			velocity = Vector2.ZERO
			var look_dir = global_position.direction_to(player.global_position).angle() - PI/2
			rotation = lerp_angle(rotation, look_dir, 15.0 * delta)
			
		DogState.CHASING:
			_move_towards_player(chase_speed, delta)

func _evaluate_state_transitions() -> void:
	if not _is_player_disguised():
		if player_in_vision and current_state != DogState.BARKING and current_state != DogState.CHASING:
			_start_barking()
			return
		
		if player_in_smell_range and current_state == DogState.PATROL:
			current_state = DogState.TRACKING
			return

	if not player_in_smell_range and not player_in_vision and current_state != DogState.PATROL:
		if current_state != DogState.BARKING:
			current_state = DogState.PATROL
			return_pat = true

func _move_towards_player(move_speed: int, delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	var rotation_direction = direction.angle() - PI/2
	rotation = lerp_angle(rotation, rotation_direction, 10.0 * delta)
	move_and_slide()

func _start_barking() -> void:
	current_state = DogState.BARKING
	velocity = Vector2.ZERO
	#bark_sound.play()
	AlertLevel.alert_up()
	bark_timer.start()

func _on_bark_timer_timeout() -> void:
	if _is_player_disguised():
		current_state = DogState.PATROL
		return_pat = true
	else:
		current_state = DogState.CHASING

func _is_player_disguised() -> bool:
	return player.caracteristics == shiftData;

func _on_smell_area_body_entered(body: Node2D) -> void:
	if body is playerMove:
		player_in_smell_range = true

func _on_smell_area_body_exited(body: Node2D) -> void:
	if body is playerMove:
		player_in_smell_range = false

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body is playerMove:
		player_in_vision = true

func _on_vision_area_body_exited(body: Node2D) -> void:
	if body is playerMove:
		player_in_vision = false

func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body is playerMove and not _is_player_disguised():
		body.onBodyEntered(self)
