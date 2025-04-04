extends Node3D
class_name Stage

var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var field :PlacedThings
var plum_list :Array
var apple_list :Array

func _ready() -> void:
	field = PlacedThings.new(Settings.FieldSize)
	draw_border()
	draw_rand_wall(100)
	field.set_at( Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1), Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	$Walls.field2wall(field)
	for i in 10:
		var pos := rand2dpos()
		if field.get_at(pos) != null:
			continue
		#field.set_at(pos, Things.Plum)
		var pl = plum_scene.instantiate().init(field, pos  , Dir8Lib.DiagonalList.pick_random(), i)
		add_child(pl)
		plum_list.append(pl)

	for i in 10:
		var pos := rand2dpos()
		if field.get_at(pos) != null:
			continue
		field.set_at(pos, Things.Apple)
		var ap = apple_scene.instantiate().init(field, pos , i)
		add_child(ap)
		apple_list.append(ap)
		ap.position = ap.get_pos3d()

func process_frame() -> void:
	for p in plum_list:
		p.move2d()
		p.position = p.get_pos3d()

func draw_border() -> void:
	field.draw_hline(0, Settings.FieldWidth-1, 0, Things.Wall)
	field.draw_hline(0,Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(0,0, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall)

func draw_rand_wall(n :int) -> void:
	for i in n:
		var pos2d = rand2dpos()
		field.set_at(pos2d, Things.Wall)

func rand2dpos() -> Vector2i:
	return Vector2i( randi_range(1,Settings.FieldWidth-2), randi_range(1,Settings.FieldHeight-2) )

func _on_timer_timeout() -> void:
	process_frame()
