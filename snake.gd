extends Node3D
class_name Snake

var pos2d_list :Array[Vector2i]
var move_dir :Dir8Lib.Dir

func init(pos :Vector2i) -> void:
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.5)
	$Body.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
	for i in Settings.SnakeLenStart:
		pos2d_list.append(pos)

func process_frame() -> void:
	var tail = pos2d_list.pop_back()
	var head = pos2d_list[0] + Dir8Lib.Dir2Vt[move_dir]
	pos2d_list.push_front(head)
	$Body.set_visible_count(pos2d_list.size())
	for i in pos2d_list.size():
		$Body.set_inst_pos(i, Settings.vector2i_to_vector3(pos2d_list[i]))
		$Body.set_inst_color(i, Color.RED)

func change_move_dir(dir :Dir8Lib.Dir) -> void:
	assert(Dir8Lib.IsDiagonal(dir), "invalid dir %s" %[dir])
