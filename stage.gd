extends Node3D
class_name Stage

var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var field :PlacedThings
var plum_list :Array
var apple_list :Array

func _ready() -> void:
	$Timer.wait_time = Settings.FrameTime
	field = PlacedThings.new(Settings.FieldSize)
	draw_border()
	draw_rand_wall(10)
	field.set_at( Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1), Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	$Walls.field2wall(field)
	for i in 100:
		var pos := rand2dpos()
		if field.get_at(pos) != null:
			continue
		var pl = plum_scene.instantiate().init(field, pos  , Dir8Lib.DiagonalList.pick_random(), i)
		add_child(pl)
		plum_list.append(pl)

	for i in 10:
		var pos := rand2dpos()
		if field.get_at(pos) != null:
			continue
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
		match randi_range(0,2):
			0:
				field.set_at(rand2dpos(), Things.Wall)
			1:
				var x1 = rand_x()
				var x2 = rand_x()
				var y = rand_y()
				field.draw_hline(x1,x2,y,Things.Wall)
			2:
				var x = rand_x()
				var y1 = rand_y()
				var y2 = rand_y()
				field.draw_vline(x,y1,y2,Things.Wall)

func rand_x() -> int:
	return randi_range(1,Settings.FieldWidth-2)
func rand_y() -> int:
	return randi_range(1,Settings.FieldHeight-2)
func rand2dpos() -> Vector2i:
	return Vector2i( rand_x(), rand_y() )

func _on_timer_timeout() -> void:
	process_frame()
