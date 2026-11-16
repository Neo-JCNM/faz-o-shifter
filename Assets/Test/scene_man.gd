extends Node
var scene_origin : String
var doors : Array[Node]
var first_spawn : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_origin = "first"
	first_spawn =false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_door():
	for door in doors:
		if door.scene_end == scene_origin :
			return door.get_children(false)[2]
