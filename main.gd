extends Node3D

func to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)

func _ready() -> void:
	var vp_size = get_viewport().get_visible_rect().size
