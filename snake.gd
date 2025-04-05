extends Node3D
class_name Snake

var pos2d_list :Array[Vector2i]
var move_dir :Dir8Lib.Dir

func _ready() -> void:
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.5)
	$Body.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)

func move_1_step() -> void:
	pass

func change_move_dir(dir :Dir8Lib.Dir) -> void:
	pass
