extends Node3D
class_name Plum

var number :int
var pos2d :Vector2i
var old_pos2d :Vector2i
var old_pos_time :float
var move_dir :Dir8Lib.Dir
var field :PlacedThings
var rotate_v :float

func _to_string() -> String:
	return "Plum%d (%d,%d) %s" % [number, pos2d.x,pos2d.y, move_dir]

func init(f :PlacedThings, p2d :Vector2i, d :Dir8Lib.Dir, n :int) -> Plum:
	number = n
	$"번호".text = "%d" % number
	field = f
	pos2d = p2d
	move_dir = d
	$"모양".mesh.material.albedo_color = Settings.LightColorList.pick_random()[0]
	$"모양".rotation.x = randf_range(-PI,PI)
	$"이동모양".mesh = $"모양".mesh
	rotate_v = randf_range(-5,5)

	var old = field.set_at(p2d, self)
	assert(old == null, "%s pos not empty %s" % [self, old])
	position = get_pos3d()
	return self

func _process(delta: float) -> void:
	$"모양".rotate_z(delta*rotate_v)
	$"이동모양".rotation = $"모양".rotation
	var vt2 = pos2d - old_pos2d
	$"이동모양".position = lerp(
		Vector3(-vt2.x, vt2.y, 0),
		Vector3.ZERO,
		(Time.get_unix_time_from_system() - old_pos_time)/Settings.FrameTime,
		)

func get_pos3d() -> Vector3:
	return Settings.vector2i_to_vector3(pos2d)

func field_get(pos :Vector2i, d :Dir8Lib.Dir):
	return field.get_at(pos + Dir8Lib.Dir2Vt[d] )

func field_get3(pos :Vector2i, d :Dir8Lib.Dir) -> Dictionary:
	return {
		"center" : field_get(pos, d),
		"right" : field_get(pos, Dir8Lib.DirTurnRight(d, 1)),
		"left" : field_get(pos, Dir8Lib.DirTurnLeft(d, 1)),
		}

func find_new_dir(oldpos2d :Vector2i, olddir :Dir8Lib.Dir) -> Dictionary:
	var 기존방향3 = field_get3(oldpos2d, olddir)
	var newdir = olddir
	var movedir = olddir
	if 기존방향3.center == null: # 진행방향이 비어 있어 통과
		newdir = olddir
		movedir = newdir
	elif 기존방향3.right == null and 기존방향3.left == null: # 진행 방향이 막혀 있어 뒤로 반사
		newdir = Dir8Lib.DirOpposite(olddir)
		movedir = newdir
		rotate_v = randf_range(-5,5)
	elif 기존방향3.right != null and 기존방향3.left != null: # 진행 방향이 막혀 있어 뒤로 반사
		newdir = Dir8Lib.DirOpposite(olddir)
		movedir = newdir
		rotate_v = randf_range(-5,5)
	elif 기존방향3.right == null and 기존방향3.left != null: # 오른쪽이 비어 있어 오른쪽으로 반사
		newdir = Dir8Lib.DirTurnRight(olddir)
		movedir = Dir8Lib.DirTurnRight(olddir, 1)
		rotate_v = randf_range(-5,5)
	elif 기존방향3.right != null and 기존방향3.left == null: # 왼쪽이 비어 있어 왼쪽으로 반사
		newdir = Dir8Lib.DirTurnLeft(olddir)
		movedir = Dir8Lib.DirTurnLeft(olddir, 1)
		rotate_v = randf_range(-5,5)
	else :
		assert(false, "find_new_dir")
	return { "dir":newdir, "move":movedir }

func move2d() -> void:
	old_pos2d = pos2d
	old_pos_time = Time.get_unix_time_from_system()
	var new_dict = find_new_dir(pos2d, move_dir)
	if field_get(pos2d, new_dict.move) == null : # 이동 가능
		pos2d = pos2d + Dir8Lib.Dir2Vt[new_dict.move]
	move_dir = new_dict.dir
	field.move(old_pos2d,pos2d)
	position = get_pos3d()
