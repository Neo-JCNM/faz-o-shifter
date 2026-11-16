extends Node

@export_group("Porte Type")
@export var closed : bool
@export var id_key_needed : int

@export_group("Changement Scene")
@export_file("*.tscn") var scene_start : String
@export_file("*.tscn") var scene_end : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("===DOOR===")
	SceneMan.scene_origin  = scene_start
	SceneMan.first_spawn = true
	get_tree().change_scene_to_file.call_deferred(scene_end)
