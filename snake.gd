extends Node3D
class_name Snake

var pos2d_list :Array[Vector2i]
var move_dir :Dir8Lib.Dir
var dest_body_len :int

func init(pos :Vector2i) -> Snake:
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.4)
	$Body.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
	dest_body_len = Settings.SnakeLenStart
	pos2d_list.append(pos)
	return self

func process_frame() -> void:
	if pos2d_list.size() >= dest_body_len:
		pos2d_list.pop_back()
	var head = pos2d_list[0] + Dir8Lib.Dir2Vt[move_dir]
	pos2d_list.push_front(head)
	$Body.set_visible_count(pos2d_list.size())
	for i in pos2d_list.size():
		var rate = (i as float) / pos2d_list.size()
		$Body.set_inst_pos(i, Settings.vector2i_to_vector3(pos2d_list[i]))
		$Body.set_inst_color(i, lerp(Color.RED, Color.BLUE, rate))

func change_move_dir(dir :Dir8Lib.Dir) -> void:
	assert(not Dir8Lib.IsDiagonal(dir), "invalid dir %s" %[dir])
	if Dir8Lib.DirOpppsite(dir) == move_dir:
		print_debug("cannot change dir %s %s" % [dir, move_dir])
		return
	move_dir = dir

var key2dir = {
	KEY_UP:Dir8Lib.Dir.North,
	KEY_DOWN:Dir8Lib.Dir.South,
	KEY_LEFT:Dir8Lib.Dir.West,
	KEY_RIGHT:Dir8Lib.Dir.East,
}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var dir = key2dir.get(event.keycode)
		if dir != null:
			change_move_dir(dir)
