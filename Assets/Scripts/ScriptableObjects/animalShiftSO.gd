extends Resource

class_name AnimalShiftSO
#Scriptable Object to define the datas inside shifted animals

@export_group("Data")
@export var animalName : String = "";
@export var zoneTag : String = "";
@export var shiftDuration : float = 100.0;

@export_group("Behaviour")
@export var sprite : SpriteFrames = null;
@export var animSound : AudioStreamMP3 = null;

@export_group("Physic")
@export var speed : int = 400;
@export var weight : int = 200;
@export var collider : RectangleShape2D = null;

@export_group("Abilities")
@export var canRun : bool = true;
@export var canCrouch : bool = false;
@export var canJump : bool = true;
