extends Resource

class_name DialogueSO
#Scriptable Object to define the datas inside shifted animals

@export_group("Data")
@export var Name : String = "";
@export var Content : String = "";
@export var portrait : CompressedTexture2D = null;




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
