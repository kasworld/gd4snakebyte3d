extends Node3D

func _ready() -> void:
	#var vp_size = get_viewport().get_visible_rect().size
	var centerx = Settings.FieldWidth as float /2
	var centery = Settings.FieldHeight as float /2
	$Camera3D.position = Vector3(centerx, centery, Settings.FieldHeight)
	$Camera3D.look_at(Vector3(centerx, centery, 0))
	$OmniLight3D.position = Vector3(centerx, centery, Settings.FieldHeight/4)
	$Stage.init(1, Settings.StageWalls[1])
	$Stage.connect("stage_cleared", stage_cleared)

func stage_cleared() -> void:
	print_debug("stage cleared")

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
