extends Node3D
class_name Stage

var field :PlacedThings

func _ready() -> void:
	field = PlacedThings.new(Settings.FieldSize)
	field.draw_hline(0, Settings.FieldWidth-1, 0, Things.Wall)
	field.draw_hline(0,Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(0,0, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall)
	field.set_at( Vector2i(Settings.FieldWidth/2, Settings.FieldHeight-1), Things.Start)
	#field.set_at( Vector2i(Settings.FieldWidth/2, 0), Things.Goal)
	$Walls.field2wall(field)
	$Plum.init(field, Vector2i(3,7) , Dir8Lib.Dir.NorthWest)

func _process(delta: float) -> void:
	$Plum.move2d()
	$Plum.position = $Plum.get_pos3d()
