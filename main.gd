extends Node3D



func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	var centerx = Settings.FieldWidth as float /2
	var centery = Settings.FieldHeight as float /2
	$Camera3D.position = Vector3(centerx, centery, Settings.FieldWidth)
	$Camera3D.look_at(Vector3(centerx, centery, 0))
	$OmniLight3D.position = Vector3(0, 0, Settings.FieldWidth)
