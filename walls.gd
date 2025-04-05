extends Node3D
class_name Walls

var field :PlacedThings

func init(f :PlacedThings) -> void:
	field = f
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.5)
	$MultiMeshShape.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
	field.exec_wall_script(Settings.BounderyWalls)
	draw_rand_wall(10)
	field2wall(field)

func field2wall(field :PlacedThings) -> void:
	var wall_count := 0
	for x in field.get_width():
		for y in field.get_height():
			var pos := Vector2i(x,y)
			if field.get_at(pos) == Things.Wall:
				var pos3d = Settings.vector2i_to_vector3(pos)
				$MultiMeshShape.set_inst_pos(wall_count, pos3d)
				$MultiMeshShape.set_inst_color(wall_count, Settings.LightColorList.pick_random()[0])
				wall_count += 1
	$MultiMeshShape.set_visible_count(wall_count)

func draw_rand_wall(n :int) -> void:
	for i in n:
		match i % 3:
			0:
				field.set_at(field.rand2dpos(2), Things.Wall)
			1:
				field.draw_hline(field.rand_x(2),field.rand_x(2),field.rand_y(2),Things.Wall)
			2:
				field.draw_vline(field.rand_x(2),field.rand_y(2),field.rand_y(2),Things.Wall)
