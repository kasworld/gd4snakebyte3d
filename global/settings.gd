extends Node

const FieldWidth :int = 48
const FieldHeight :int = 27
const FieldSize := Vector2i(FieldWidth,FieldHeight)

func vector2i_to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)

const FrameTime := 0.5 # second
