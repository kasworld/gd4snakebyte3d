class_name Dir8Lib

enum Dir {
	North,
	NorthWest,
	West,
	WestSouth,
	South,
	SouthEast,
	East,
	EastNorth,
}

static func Dir2Str(d :Dir) -> String:
	return Dir.keys()[d]

static func DirOpppsite(d :Dir) -> Dir:
	return (d + Dir.size()/2) % Dir.size()

static func DirTurnLeft(d :Dir) -> Dir:
	return (d + 2 ) % Dir.size()

static func DirTurnRight(d :Dir) -> Dir:
	return (d - 2 + Dir.size()) % Dir.size()

const Dir2Vt = {
	Dir.North : Vector2i(0,-1),
	Dir.NorthWest : Vector2i(-1,-1),
	Dir.West : Vector2i(-1,0),
	Dir.WestSouth : Vector2i(-1,1),
	Dir.South : Vector2i(0, 1),
	Dir.SouthEast : Vector2i(1, 1),
	Dir.East : Vector2i(1,0),
	Dir.EastNorth : Vector2i(1,-1),
}

static func dir2rad(d:Dir) -> float:
	return deg_to_rad(d *45.0)

enum Flag {
	North = 1 << Dir.North,
	NorthWest = 1 << Dir.NorthWest,
	West = 1 << Dir.West,
	WestSouth = 1 << Dir.WestSouth,
	South = 1 << Dir.South,
	SouthEast = 1 << Dir.SouthEast,
	East = 1 << Dir.East,
	EastNorth = 1 << Dir.EastNorth,
}

const Flag2Dir = {
	Flag.North : Dir.North,
	Flag.NorthWest : Dir.NorthWest,
	Flag.West : Dir.West,
	Flag.WestSouth : Dir.WestSouth,
	Flag.South : Dir.South,
	Flag.SouthEast : Dir.SouthEast,
	Flag.East : Dir.East,
	Flag.EastNorth : Dir.EastNorth,
}
const Dir2Flag = {
	Dir.North : Flag.North,
	Dir.NorthWest : Flag.NorthWest,
	Dir.West : Flag.West,
	Dir.WestSouth : Flag.WestSouth,
	Dir.South : Flag.South,
	Dir.SouthEast : Flag.SouthEast,
	Dir.East : Flag.East,
	Dir.EastNorth : Flag.EastNorth,
}

static func Flag2Str(d :Flag) -> String:
	return Flag.keys()[d]

static func FlagOpppsite(f :Flag) -> Flag:
	return Dir2Flag[ DirOpppsite(Flag2Dir[f]) ]

static func FlagTurnLeft(f :Flag) -> Flag:
	return Dir2Flag[ DirTurnLeft(Flag2Dir[f]) ]

static func FlagTurnRight(f :Flag) -> Flag:
	return Dir2Flag[ DirTurnRight(Flag2Dir[f]) ]

static func Flag2Vt(f :Flag) -> Vector2i:
	return Dir2Vt[Flag2Dir[f]]
