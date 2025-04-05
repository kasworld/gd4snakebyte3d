extends Node

const FieldWidth :int = 48
const FieldHeight :int = 27
const FieldSize := Vector2i(FieldWidth,FieldHeight)

func vector2i_to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)

const FrameTime := 0.4 # second

var BounderyWalls = [
	["hline", 0, Settings.FieldWidth-1, 0, Things.Wall ],
	["hline", 0, Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall ],
	["vline", 0, 0, Settings.FieldHeight-1, Things.Wall ],
	["vline", Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall ],
]

var LightColorList = NamedColorList.make_light_color_list()

const SnakeLenStart := 8
const SankeLenInc := 4
const StartPos := Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1)
const GoalPos := Vector2i(Settings.FieldWidth/2, 0)
