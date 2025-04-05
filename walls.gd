extends Node3D
class_name Walls

var field :PlacedThings
var wall_list :Array

func init(f :PlacedThings) -> void:
	field = f
	wall_list = []
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Sphere, 0.5)
	$MultiMeshShape.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
	exec_script(Settings.BounderyWalls)
	draw_rand_wall(10)
	field2wall(field)

func field2wall(field :PlacedThings) -> void:
	var wall_count := 0
	for l in wall_list:
		var co = Settings.LightColorList.pick_random()[0]
		for pos in l:
			field.set_at(pos, Things.Wall)
			var pos3d = Settings.vector2i_to_vector3(pos)
			$MultiMeshShape.set_inst_pos(wall_count, pos3d)
			$MultiMeshShape.set_inst_color(wall_count, co)
			wall_count += 1
	$MultiMeshShape.set_visible_count(wall_count)

func draw_rand_wall(n :int) -> void:
	for i in n:
		match i % 3:
			0:
				set_at(field.rand2dpos(2))
			1:
				draw_hline(field.rand_x(2),field.rand_x(2),field.rand_y(2))
			2:
				draw_vline(field.rand_x(2),field.rand_y(2),field.rand_y(2))

func set_at(pos :Vector2i):
	wall_list.append([pos])
# include x2
func draw_hline(x1 :int, x2 :int, y :int):
	if x1 > x2 :
		var t = x1
		x1 = x2
		x2 = t
	var rtn := []
	for x in range(x1,x2+1):
		rtn.append( Vector2i(x,y) )
	wall_list.append(rtn)

# include y2
func draw_vline(x :int, y1 :int, y2 :int):
	if y1 > y2 :
		var t = y1
		y1 = y2
		y2 = t
	var rtn := []
	for y in range(y1,y2+1):
		rtn.append( Vector2i(x,y) )
	wall_list.append(rtn)

func exec_script(sc :Array) -> Array:
	var rtn := []
	for l in sc:
		rtn.append(exec_script_line(l))
	return rtn

func exec_script_line(l:Array):
	var rtn
	match l[0]:
		"set" :
			set_at(Vector2i(l[1],l[2]))
		"hline":
			draw_hline(l[1],l[2],l[3])
		"vline":
			draw_vline(l[1],l[2],l[3])
		_:
			assert(false, "invalid script line %s" %[l])
	return rtn
