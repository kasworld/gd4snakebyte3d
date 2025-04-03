extends Node

const FieldWidth :int = 64
const FieldHeight :int = 36
const FieldSize := Vector2i(FieldWidth,FieldHeight)

func vector2i_to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)
