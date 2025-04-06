extends Node3D
class_name Stage

class Start:
	pass
class Goal:
	pass
class Wall:
	pass

var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var field :PlacedThings
var plum_list :Array
var number :int
var apple_make_count :int
var apple_eat_count :int
var apple_end_count :int

func init(n :int) -> Stage:
	number = n
	$StageNumber.text = "stage %d" % number
	$AppleNumber.text = "apple %d" % Settings.AppleCountPerStage
	$StageNumber.position.x = 2
	$AppleNumber.position.x = Settings.FieldWidth - 3
	$Timer.wait_time = Settings.FrameTime
	field = PlacedThings.new(Settings.FieldSize)
	$Walls.init(field, [])
	#$Walls.init(field, Settings.Stage1Walls)
	field.set_at( Settings.StartPos, Start.new())
	for i in Settings.PlumCount:
		add_plum(i)
	for i in 1:
		add_apple()
	apple_end_count = Settings.AppleCountPerStage
	$Snake.init(field, Settings.StartPos)
	$Snake.connect("eat_apple", snake_eat_apple)
	$Snake.connect("snake_dead", snake_die)
	return self

func snake_die() -> void:
	print_debug("snake die")

func snake_eat_apple(pos :Vector2i) -> void:
	var ap = field.get_at(pos)
	assert(ap is Apple, "eat not apple %s %s" %[ ap, pos])
	ap.delete()
	ap.queue_free()
	apple_eat_count += 1
	if apple_eat_count >= apple_end_count:
		$Walls.open_goalpos()
		return
	add_apple()

func add_plum(i:int) -> void:
	var pos := field.find_empty_pos(10)
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var pl = plum_scene.instantiate().init(field, pos , Dir8Lib.DiagonalList.pick_random(), i)
	add_child(pl)
	plum_list.append(pl)

func add_apple() -> void:
	apple_make_count +=1
	var ap = apple_scene.instantiate().init(field, apple_make_count)
	add_child(ap)

func process_frame() -> void:
	for p in plum_list:
		p.move2d()
	$Snake.process_frame()

func _on_timer_timeout() -> void:
	process_frame()
