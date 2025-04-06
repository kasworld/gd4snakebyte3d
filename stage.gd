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
var number :int
var apple_make_count :int
var apple_eat_count :int
var apple_end_count :int
var wall_script :Array
var snake :Snake

func _to_string() -> String:
	return "Stage%d" % [number]

func init(n :int, w_script :Array) -> Stage:
	var vp_size = get_viewport().get_visible_rect().size
	$StageStartPanel.size = vp_size/2
	$StageStartPanel.position = vp_size/4
	$StageStartPanel/Label.text = "stage %d" % number
	$StageStartPanel.visible =  true
	$HidePanelTimer.start(3)

	number = n
	$StageNumber.text = "stage %d" % number
	$AppleNumber.text = "apple %d" % Settings.AppleCountPerStage
	$StageNumber.position.x = 2
	$AppleNumber.position.x = Settings.FieldWidth - 3
	$FrameTimer.wait_time = Settings.FrameTime
	apple_end_count = Settings.AppleCountPerStage
	wall_script = w_script
	new_snake()
	return self

func new_snake() -> Stage:
	if snake != null :
		snake.queue_free()
	for pl in plum_list:
		pl.queue_free()
	plum_list = []
	for n in $AppleContainer.get_children():
		n.queue_free()
	apple_make_count = apple_eat_count
	field = PlacedThings.new(Settings.FieldSize)
	$Walls.init(field, wall_script)
	field.set_at( Settings.StartPos, Start.new())
	for i in Settings.PlumCount:
		add_plum(i)
	if apple_eat_count >= apple_end_count:
		$Walls.open_goalpos()
	else:
		for i in 1:
			add_apple()
	update_info_text	()
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

func update_info_text() -> void:
	$AppleNumber.text = "apple %d/%d" % [apple_eat_count, apple_end_count]

func snake_eat_apple(pos :Vector2i) -> void:
	var ap = field.get_at(pos)
	assert(ap is Apple, "eat not apple %s %s" %[ ap, pos])
	ap.delete()
	ap.queue_free()
	apple_eat_count += 1
	update_info_text	()
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
	$AppleContainer.add_child(ap)

func process_frame() -> void:
	for p in plum_list:
		p.move2d()
	if snake != null :
		snake.process_frame()

func _on_hide_panel_timer_timeout() -> void:
	$HidePanelTimer.stop()
	$StageStartPanel.hide()
	$FrameTimer.start()

func _on_frame_timer_timeout() -> void:
	process_frame()
