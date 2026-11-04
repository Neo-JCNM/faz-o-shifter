extends Resource

class_name AnimalShiftSO
#Scriptable Object to define the datas inside shifted animals
@export_group("Data")
@export var animalName : String = "";
@export var zoneTag : String = "";

@export_group("Behaviour")
@export var animalSkin : SpriteFrames = null;
@export var animalAnimSound : AudioStreamMP3 = null;

@export_group("Physic")
@export var animalSpeed : int = 400;
@export var animalWeight : int = 200;
@export var animalCollider : BoxShape3D = null;

@export_group("Abilities")
@export var canRun : bool = true;
@export var canCrouch : bool = false;
@export var canJump : bool = true;



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
