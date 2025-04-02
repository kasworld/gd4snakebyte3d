extends Node3D
class_name Stage

var field :PlacedThings

func _ready() -> void:
	field = PlacedThings.new(Settings.FieldSize)
	field.draw_hline(0, Settings.FieldWidth-1, 0, Things.Wall)
	field.draw_hline(0,Settings.FieldWidth-1, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(0,0, Settings.FieldHeight-1, Things.Wall)
	field.draw_vline(Settings.FieldWidth-1, 0, Settings.FieldHeight-1, Things.Wall)
	$Walls.field2wall(field)
