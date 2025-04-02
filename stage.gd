extends Node3D
class_name Stage

var field :PlacedThings

func _ready() -> void:
	field = PlacedThings.new(Settings.FieldSize)
