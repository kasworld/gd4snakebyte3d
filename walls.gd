extends Node3D
class_name Walls

var field :PlacedThings
var wall_list :Array
var startwall_index :int
var goalwall_index :int
var animate_inst :Dictionary

func init(f :PlacedThings, add_walls :Array) -> void:
	field = f
	wall_list = []
	var mesh = ShapeLib.new_mesh_by_type(ShapeLib.Shape.Box, 0.4)
	$MultiMeshShape.init(mesh, Color.WHITE, Settings.FieldWidth*Settings.FieldHeight/2, Vector3.ZERO)
	exec_script(Settings.BounderyWalls)
	exec_script(add_walls)
	field2wall()
	# stop old animation
	animate_inst = {
		"start_time" : 0,
		"inst_index" : 0,
		"ani_dur_sec" : 0,
		"pos1" :Vector3.ZERO,
		"pos2" :Vector3.ZERO,
	}

func field2wall() -> void:
	var wall_count := 0
	for l in wall_list:
		var co = Settings.LightColorList.pick_random()[0]
		for pos in l:
			if pos == Settings.GoalPos:
				goalwall_index = wall_count
			if pos == Settings.StartPos:
				startwall_index = wall_count
				pos = pos + Dir8Lib.Dir2Vt[Dir8Lib.Dir.SouthEast]
			else:
				field.set_at(pos, self)
			var pos3d = Settings.vector2i_to_vector3(pos)
			$MultiMeshShape.set_inst_pos(wall_count, pos3d)
			$MultiMeshShape.set_inst_color(wall_count, co)
			wall_count += 1
	$MultiMeshShape.set_visible_count(wall_count)

func close_startpos() -> void:
	var pos = Settings.StartPos
	field.set_at(pos, self)
	var pos1 = Settings.vector2i_to_vector3(Settings.StartPos+Dir8Lib.Dir2Vt[Dir8Lib.Dir.SouthEast])
	var pos2 = Settings.vector2i_to_vector3(Settings.StartPos)
	animate_inst = {
		"start_time" : Time.get_unix_time_from_system(),
		"inst_index" : startwall_index,
		"ani_dur_sec" : 1,
		"pos1" : pos1,
		"pos2" : pos2,
	}

func open_goalpos() -> void:
	var pos = Settings.GoalPos
	var old = field.set_at( pos, Stage.Goal.new())
	assert(old == self, "invalid goal pos not wall %s %s" % [pos,old])
	var pos1 = Settings.vector2i_to_vector3(Settings.GoalPos)
	var pos2 = Settings.vector2i_to_vector3(Settings.GoalPos+Dir8Lib.Dir2Vt[Dir8Lib.Dir.NorthWest])
	animate_inst = {
		"start_time" : Time.get_unix_time_from_system(),
		"inst_index" : goalwall_index,
		"ani_dur_sec" : 1,
		"pos1" : pos1,
		"pos2" : pos2,
	}

func _process(_delta: float) -> void:
	if animate_inst.start_time != 0:
		var rate = (Time.get_unix_time_from_system() - animate_inst.start_time) / animate_inst.ani_dur_sec
		var pos = lerp(animate_inst.pos1, animate_inst.pos2, rate )
		$MultiMeshShape.set_inst_pos(animate_inst.inst_index, pos)
		if rate >= 1 :
			animate_inst.start_time = 0

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

func exec_script(sc :Array):
	for l in sc:
		exec_script_line(l)

func exec_script_line(l:Array):
	match l[0]:
		"set" :
			set_at(Vector2i(l[1],l[2]))
		"hline":
			draw_hline(l[1],l[2],l[3])
		"vline":
			draw_vline(l[1],l[2],l[3])
		_:
			assert(false, "invalid script line %s" %[l])
