extends Node

const FieldWidth :int = 48
const FieldHeight :int = 27
const FieldSize := Vector2i(FieldWidth,FieldHeight)

func vector2i_to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)

const FrameTime := 0.5 # second

var BounderyWalls = [
	["hline", 0, Settings.FieldWidth-1, 0, Things.Wall ],
	["hline", 0, Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall ],
	["vline", 0, 0, Settings.FieldHeight-1, Things.Wall ],
	["vline", Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall ],
]
