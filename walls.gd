extends Node3D
class_name Walls

func _ready() -> void:
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.5)
	$MultiMeshShape.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)

func field2wall(field :PlacedThings) -> void:
	var wall_count := 0
	for x in field.get_width():
		for y in field.get_height():
			var pos := Vector2i(x,y)
			if field.get_at(pos) == Things.Wall:
				var pos3d = Settings.vector2i_to_vector3(pos)
				$MultiMeshShape.set_inst_pos(wall_count, pos3d)
				$MultiMeshShape.set_inst_color(wall_count, NamedColorList.color_list.pick_random()[0])
				wall_count += 1
	$MultiMeshShape.set_visible_count(wall_count)
