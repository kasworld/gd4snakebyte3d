extends Node

const FieldWidth :int = 48
const FieldHeight :int = 27
const FieldSize := Vector2i(FieldWidth,FieldHeight)
const FrameTime := 0.4 # second
const SnakeLenStart := 12
const SankeLenInc := 12
const PlumCount := 2
const AppleCountPerStage := 1
const AppleIncOnTimeOut := 3

func vector2i_to_vector3(from :Vector2i) -> Vector3:
	return Vector3(from.x,Settings.FieldHeight - from.y, 0)

const StartPos := Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1)
const GoalPos := Vector2i(Settings.FieldWidth/2, 0)
var BounderyWalls = [
	["hline", 0, Settings.FieldWidth-2, 0],
	["vline", Settings.FieldWidth-1, 0, Settings.FieldHeight-2],
	["hline", 1, Settings.FieldWidth-1, Settings.FieldHeight-1],
	["vline", 0, 1, Settings.FieldHeight-1],
]
var Stage1Walls = [
	["hline", 5, Settings.FieldWidth/2-2, Settings.FieldHeight/2],
	["hline", Settings.FieldWidth/2+2, Settings.FieldWidth-1-5, Settings.FieldHeight/2],
	["vline", Settings.FieldWidth/2, 5, Settings.FieldHeight/2-2],
	["vline", Settings.FieldWidth/2, Settings.FieldHeight/2+2, Settings.FieldHeight-1-5],
]

var LightColorList = NamedColorList.make_light_color_list()
