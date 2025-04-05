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
	$StageNumber.text = "stage %d" % number
	$AppleNumber.text = "apple %d" % Settings.AppleCountPerStage
	$StageNumber.position.x = 2
	$AppleNumber.position.x = Settings.FieldWidth - 3
	$Timer.wait_time = Settings.FrameTime
	field = PlacedThings.new(Settings.FieldSize)
	$Walls.init(field, Settings.Stage1Walls)
	field.set_at( Settings.StartPos, Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	for i in Settings.PlumCount:
		add_plum(i)
	for i in 1:
		add_apple(i)
	$Snake.init(field, Settings.StartPos)
	return self

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
	$Snake.process_frame()

func _on_timer_timeout() -> void:
	process_frame()
