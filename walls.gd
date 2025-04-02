extends Node3D
class_name Walls

func _ready() -> void:
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Box, 0.5)
	$MultiMeshShape.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
