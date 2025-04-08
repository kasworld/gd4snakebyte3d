extends Node3D

var stage_scene = preload("res://stage.tscn")

func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	$DemoPanel.size = vp_size/3
	$DemoPanel.position = Vector2(vp_size.x/2, vp_size.y/4) - vp_size/6
	var centerx = Settings.FieldWidth as float /2
	var centery = Settings.FieldHeight as float /2
	$Camera3D.position = Vector3(centerx, centery, Settings.FieldHeight)
	$Camera3D.look_at(Vector3(centerx, centery, 0))
	$OmniLight3D.position = Vector3(centerx, centery, Settings.FieldHeight/4)
	new_game()

var stage_number :int
var stage :Stage
var game_info :Dictionary
var demo_mode :bool = true
func new_game() -> void:
	game_info = {
		"score" : 0,
		"snake" : Settings.SnakeLife,
	}
	stage_number = 0
	start_stage()

func end_demo_start_game() -> void:
	demo_mode = false
	$DemoPanel.visible = demo_mode
	new_game()

func start_stage() -> void:
	if stage != null :
		stage.queue_free()
	stage = stage_scene.instantiate().set_demo_mode(demo_mode)
	add_child(stage)
	stage.init(game_info, stage_number+1, Settings.StageWalls[stage_number % Settings.StageWalls.size()])
	stage.connect("stage_cleared", stage_cleared)
	stage.connect("snake_dead", snake_dead)
	stage_number +=1

func stage_cleared() -> void:
	print_debug("stage cleared %s" [stage_number])
	game_info.snake += Settings.SnakeLifeIncOnStageClear
	start_stage()

func snake_dead() -> void:
	game_info.snake -= 1
	if game_info.snake > 0:
		stage.new_snake()
	else:
		game_over()

func game_over() -> void:
	$DemoPanel/Label.text = "GAME OVER\nPress Space to start"
	demo_mode = true
	$DemoPanel.visible = demo_mode
	new_game()
	#$HidePanelTimer.start(3)

func _on_hide_panel_timer_timeout() -> void:
	pass

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_SPACE:end_demo_start_game,
}
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()
