extends Node3D

const WorldSize := Vector3(160,90,80)

var stage_number :int
var stage :SnakeByte
var game_info :Dictionary
var demo_mode :bool = true

func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	$DemoPanel.size = vp_size/3
	$DemoPanel.position = Vector2(vp_size.x/2, vp_size.y/4) - vp_size/6

	$MovingCameraLightHober.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z),  WorldSize.length()*3)
	$MovingCameraLightAround.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, WorldSize.z),  WorldSize.length()*3)
	$AxisArrow3D.set_colors().set_size(WorldSize.length()/20)
	$GlassCabinet.init(WorldSize)
	$GlassCabinet.get_camera_light().make_current()

	new_game()

func new_game() -> void:
	game_info = {
		"score" : 0,
		"snake" : SnakeByte.SnakeLife,
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
	stage = preload("res://snake_byte/snake_byte.tscn").instantiate().set_demo_mode(demo_mode)
	add_child(stage)
	stage.init(game_info, stage_number+1, SnakeByte.StageSnakeByteWalls[stage_number % SnakeByte.StageSnakeByteWalls.size()])
	stage.connect("stage_cleared", stage_cleared)
	stage.connect("snake_dead", snake_dead)
	stage_number +=1

func stage_cleared() -> void:
	print_debug("stage cleared %s" [stage_number])
	game_info.snake += SnakeByte.SnakeLifeIncOnStageClear
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

func _process(delta: float) -> void:
	var now := Time.get_unix_time_from_system()
	if $MovingCameraLightHober.is_current_camera():
		$MovingCameraLightHober.move_hober_around_z(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )
	elif $MovingCameraLightAround.is_current_camera():
		$MovingCameraLightAround.move_wave_around_y(now/2.3, Vector3.ZERO, WorldSize.length()/2, WorldSize.length()/4 )

func _on_카메라변경_pressed() -> void:
	MovingCameraLight.NextCamera()

func _on_button_fov_up_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().camera_fov_inc()

func _on_button_fov_down_pressed() -> void:
	MovingCameraLight.GetCurrentCamera().camera_fov_dec()

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
	KEY_ENTER:_on_카메라변경_pressed,
	KEY_PAGEUP:_on_button_fov_up_pressed,
	KEY_PAGEDOWN:_on_button_fov_down_pressed,
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
