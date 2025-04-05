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
	$Label3D.text = "stage %d" % number
	return self

func _ready() -> void:
	$Timer.wait_time = Settings.FrameTime
	field = PlacedThings.new(Settings.FieldSize)
	field.exec_wall_script(Settings.BounderyWalls)
	draw_rand_wall(10)
	field.set_at( Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1), Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	$Walls.field2wall(field)
	for i in 2:
		add_plum(i)
	for i in 1:
		add_apple(i)

func add_plum(i:int) -> void:
	var pos := field.find_empty_pos(10)
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var pl = plum_scene.instantiate().init(field, pos  , Dir8Lib.DiagonalList.pick_random(), i)
	add_child(pl)
	plum_list.append(pl)

func add_apple(i:int) -> void:
	var pos := field.find_empty_pos(10)
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var ap = apple_scene.instantiate().init(field, pos, i)
	add_child(ap)
	apple_list.append(ap)

func process_frame() -> void:
	for p in plum_list:
		p.move2d()

func draw_rand_wall(n :int) -> void:
	for i in n:
		match i % 3:
			0:
				field.set_at(field.rand2dpos(2), Things.Wall)
			1:
				field.draw_hline(field.rand_x(2),field.rand_x(2),field.rand_y(2),Things.Wall)
			2:
				field.draw_vline(field.rand_x(2),field.rand_y(2),field.rand_y(2),Things.Wall)

func _on_timer_timeout() -> void:
	process_frame()
