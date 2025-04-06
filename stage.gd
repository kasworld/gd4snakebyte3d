extends Node3D
class_name Stage

signal stage_cleared()

class Start:
	pass
class Goal:
	pass
class Wall:
	pass

var snake_scene = preload("res://snake.tscn")
var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var field :PlacedThings
var plum_list :Array
var apple_list :Array
var number :int
var apple_make_count :int
var apple_eat_count :int
var apple_end_count :int
var wall_script :Array
var snake :Snake

func init(n :int, w_script :Array) -> Stage:
	number = n
	$StageNumber.text = "stage %d" % number
	$AppleNumber.text = "apple %d" % Settings.AppleCountPerStage
	$StageNumber.position.x = 2
	$AppleNumber.position.x = Settings.FieldWidth - 3
	$Timer.wait_time = Settings.FrameTime
	wall_script = w_script
	new_snake()
	return self

func new_snake() -> Stage:
	if snake != null :
		snake.queue_free()
	for pl in plum_list:
		pl.queue_free()
	plum_list = []
	apple_make_count -= apple_list.size()
	for ap in apple_list:
		ap.queue_free()
	apple_list = []
	field = PlacedThings.new(Settings.FieldSize)
	$Walls.init(field, wall_script)
	field.set_at( Settings.StartPos, Start.new())
	for i in Settings.PlumCount:
		add_plum(i)
	for i in 1:
		add_apple()
	apple_end_count = Settings.AppleCountPerStage
	snake = snake_scene.instantiate()
	add_child(snake)
	snake.connect("eat_apple", snake_eat_apple)
	snake.connect("snake_dead", snake_die)
	snake.connect("tail_enter", snake_enter_complete)
	snake.connect("reach_goal", snake_reach_goal)
	snake.init(field)
	return self

func snake_die() -> void:
	new_snake()

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

func snake_reach_goal() -> void:
	stage_cleared.emit()

func snake_enter_complete() -> void:
	$Walls.close_startpos()

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
	apple_list.append(ap)

func process_frame() -> void:
	for p in plum_list:
		p.move2d()
	if snake != null :
		snake.process_frame()

func _on_timer_timeout() -> void:
	process_frame()
