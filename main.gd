extends Node3D



func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
	$Camera3D.position = Vector3(Settings.FieldWidth/2,Settings.FieldHeight/2,Settings.FieldWidth)
	$Camera3D.look_at(Vector3(Settings.FieldWidth/2,Settings.FieldHeight/2,0))
	$OmniLight3D.position = Vector3(Settings.FieldWidth/2,Settings.FieldHeight/2,Settings.FieldWidth)
