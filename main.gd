extends Node3D

var stage_scene = preload("res://stage.tscn")

func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	$DemoPanel.size = vp_size/2
	$DemoPanel.position = vp_size/4
	var centerx = Settings.FieldWidth as float /2
	var centery = Settings.FieldHeight as float /2
	$Camera3D.position = Vector3(centerx, centery, Settings.FieldHeight)
	$Camera3D.look_at(Vector3(centerx, centery, 0))
	$OmniLight3D.position = Vector3(centerx, centery, Settings.FieldHeight/4)
	game_info = {
		"score" : 0,
		"snake" : Settings.SnakeLife,
	}
	start_stage()

var stage_number :int
var stage :Stage
var game_info :Dictionary

func start_stage() -> void:
	if stage != null :
		stage.queue_free()
	stage = stage_scene.instantiate()
	add_child(stage)
	stage.init(game_info, stage_number+1, Settings.StageWalls[stage_number % Settings.StageWalls.size()])
	stage.connect("stage_cleared", stage_cleared)
	stage_number +=1

func stage_cleared() -> void:
	print_debug("stage cleared %s" [stage_number])
	game_info.snake += Settings.SnakeLifeIncOnStageClear
	start_stage()

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
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
