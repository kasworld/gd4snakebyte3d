extends Node3D
class_name Stage

var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var field :PlacedThings
var plum_list :Array
var apple_list :Array
var number :int

func init(n :int) -> Stage:
	number = n
	return self

func _ready() -> void:
	$Timer.wait_time = Settings.FrameTime
	field = PlacedThings.new(Settings.FieldSize)
	draw_border()
	draw_rand_wall(10)
	field.set_at( Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1), Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	$Walls.field2wall(field)
	for i in 100:
		add_plum(i)
	for i in 10:
		add_apple(i)

func add_plum(i:int) -> void:
	var pos := find_empty_pos(10)
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var pl = plum_scene.instantiate().init(field, pos  , Dir8Lib.DiagonalList.pick_random(), i)
	add_child(pl)
	plum_list.append(pl)

func add_apple(i:int) -> void:
	var pos := find_empty_pos(10)
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var ap = apple_scene.instantiate().init(field, pos, i)
	add_child(ap)
	apple_list.append(ap)

func process_frame() -> void:
	for p in plum_list:
		p.move2d()

func draw_border() -> void:
	field.draw_hline(0, Settings.FieldWidth-1, 0, Things.Wall)
	field.draw_hline(0,Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(0,0, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall)

func draw_rand_wall(n :int) -> void:
	for i in n:
		match i % 3:
			0:
				field.set_at(rand2dpos(2), Things.Wall)
			1:
				var x1 = rand_x(2)
				var x2 = rand_x(2)
				var y = rand_y(2)
				field.draw_hline(x1,x2,y,Things.Wall)
			2:
				var x = rand_x(2)
				var y1 = rand_y(2)
				var y2 = rand_y(2)
				field.draw_vline(x,y1,y2,Things.Wall)

func rand_x(margin :int=1) -> int:
	return randi_range(margin,Settings.FieldWidth-1-margin)
func rand_y(margin :int=1) -> int:
	return randi_range(margin,Settings.FieldHeight-1-margin)
func rand2dpos(margin :int=1) -> Vector2i:
	return Vector2i( rand_x(margin), rand_y(margin) )
func find_empty_pos(trycount :int) -> Vector2i:
	for i in trycount:
		var pos := rand2dpos()
		if field.get_at(pos) == null:
			return pos
	return Vector2i(-1,-1)

func _on_timer_timeout() -> void:
	process_frame()
