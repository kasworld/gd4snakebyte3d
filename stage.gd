extends Node3D
class_name Stage

signal stage_cleared()
signal snake_dead()

class Start:
	pass
class Goal:
	pass
class Wall:
	pass

var snake_scene = preload("res://snake.tscn")
var plum_scene = preload("res://plum.tscn")
var apple_scene = preload("res://apple.tscn")
var gauge_scene = preload("res://step_over_gauge.tscn")
var field :PlacedThings
var plum_list :Array
var number :int
var apple_make_count :int
var apple_eat_count :int
var apple_end_count :int
var wall_script :Array
var snake :Snake
var snake_step_after_eat :int
var gauge :StepOverGauge
var game_info :Dictionary
func _to_string() -> String:
	return "Stage%d %s" % [number, game_info]

func init(gameinfo :Dictionary, n :int, w_script :Array) -> Stage:
	number = n
	wall_script = w_script
	game_info = gameinfo
	var vp_size = get_viewport().get_visible_rect().size
	$StageStartPanel.size = vp_size/2
	$StageStartPanel.position = vp_size/4

	$StageInfo.text = "stage %d" % number
	$StageInfo.position.x = 2
	$SnakeInfo.position.x = Settings.FieldWidth /3
	$AppleInfo.position.x = Settings.FieldWidth - 3
	update_apple_info()
	update_snake_info()
	$FrameTimer.wait_time = Settings.FrameTime
	apple_end_count = Settings.AppleCountPerStage
	gauge = gauge_scene.instantiate().init(Settings.EatStepOverLimit, Settings.FieldHeight)
	gauge.position = Settings.vector2i_to_vector3(Vector2i(Settings.FieldWidth,Settings.FieldHeight-1))
	add_child(gauge)
	new_snake()
	return self

func show_start_panel() -> void:
	$FrameTimer.stop()
	$StageStartPanel/Label.text = "stage %d" % [ number ]
	$StageStartPanel.visible =  true
	$HidePanelTimer.start(1)

func _on_hide_panel_timer_timeout() -> void:
	$HidePanelTimer.stop()
	$StageStartPanel.hide()
	$FrameTimer.start()

func new_snake() -> Stage:
	if snake != null :
		snake.queue_free()
	for pl in plum_list:
		pl.queue_free()
	plum_list = []
	for n in $AppleContainer.get_children():
		n.queue_free()

	show_start_panel()
	snake_step_after_eat = 0
	apple_make_count = apple_eat_count
	field = PlacedThings.new(Settings.FieldSize)
	$Walls.init(field, wall_script)
	field.set_at( Settings.StartPos, Start.new())
	for i in Settings.PlumCount:
		add_plum(i)
	if apple_eat_count >= apple_end_count:
		$Walls.open_goalpos()
	else:
		add_apple()
	update_apple_info()
	update_snake_info()
	snake = snake_scene.instantiate()
	add_child(snake)
	snake.connect("eat_apple", snake_eat_apple)
	snake.connect("snake_dead", snake_die)
	snake.connect("tail_enter", snake_enter_complete)
	snake.connect("reach_goal", snake_reach_goal)
	snake.init(field)
	return self

func snake_die() -> void:
	snake_dead.emit()

func update_apple_info() -> void:
	$AppleInfo.text = "apple %d/%d" % [apple_eat_count, apple_end_count]

func update_snake_info() -> void:
	$SnakeInfo.text = "score:%d snake:%d" % [game_info.score, game_info.snake]

func snake_eat_apple(pos :Vector2i) -> void:
	var ap = field.get_at(pos)
	assert(ap is Apple, "eat not apple %s %s" %[ ap, pos])
	ap.delete()
	ap.queue_free()
	apple_eat_count += 1
	game_info.score += Settings.ScorePerApple
	snake_step_after_eat = 0
	update_apple_info()
	update_snake_info()
	if apple_eat_count >= apple_end_count:
		$Walls.open_goalpos()
		return
	if $AppleContainer.get_child_count() <= 1:
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
	if snake != null and snake.is_alive:
		snake.process_frame()
		if apple_eat_count < apple_end_count:
			snake_step_after_eat += 1
			if snake_step_after_eat >= Settings.EatStepOverLimit:
				snake_step_after_eat = 0
				for i in Settings.AppleIncOnStepOver:
					add_apple()
				apple_end_count += Settings.AppleIncOnStepOver
				update_apple_info()
			gauge.set_value(snake_step_after_eat)
	else:
		gauge.set_value(0)

func _on_frame_timer_timeout() -> void:
	process_frame()
