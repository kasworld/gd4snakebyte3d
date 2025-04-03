extends Node3D
class_name Plum

var pos2d :Vector2i
var move_dir :Dir8Lib.Dir
var field :PlacedThings

func _to_string() -> String:
	return "Plum (%d,%d) %s" % [pos2d.x,pos2d.y, move_dir]

func init(f :PlacedThings, p2d :Vector2i, d :Dir8Lib.Dir) -> Plum:
	field = f
	pos2d = p2d
	move_dir = d
	return self

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

func find_new_dir(old_pos2d :Vector2i, old_dir :Dir8Lib.Dir) -> Dir8Lib.Dir:
	var 기존방향3 = field_get3(old_pos2d, old_dir)
	var new_dir = old_dir
	if 기존방향3.center == null: # 진행방향이 비어 있어 통과
		new_dir = old_dir
	elif 기존방향3.right == null and 기존방향3.left == null: # 진행 방향이 막혀 있어 뒤로 반사
		new_dir = Dir8Lib.DirOpppsite(old_dir)
	elif 기존방향3.right != null and 기존방향3.left != null: # 진행 방향이 막혀 있어 뒤로 반사
		new_dir = Dir8Lib.DirOpppsite(old_dir)
	elif 기존방향3.right == null and 기존방향3.left != null: # 오른쪽이 비어 있어 오른쪽으로 반사
		new_dir = Dir8Lib.DirTurnRight(old_dir)
	elif 기존방향3.right != null and 기존방향3.left == null: # 왼쪽이 비어 있어 왼쪽으로 반사
		new_dir = Dir8Lib.DirTurnLeft(old_dir)
	return new_dir

func move2d() -> void:
	var new_dir = find_new_dir(pos2d, move_dir)
	if field_get(pos2d, new_dir) == null : # 이동 가능
		move_dir = new_dir
		pos2d = pos2d + Dir8Lib.Dir2Vt[move_dir]
	else:
		print_debug(self)
		move_dir = Dir8Lib.DiagonalList.pick_random()
