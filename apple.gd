extends Node3D
class_name Apple

var number :int
var pos2d :Vector2i
var field :PlacedThings
var rotate_v :float

func _to_string() -> String:
	return "Apple%d (%d,%d)" % [number, pos2d.x,pos2d.y]

func init(f :PlacedThings, p2d :Vector2i, n :int) -> Apple:
	number = n
	$"번호".text = "%d" % number
	field = f
	pos2d = p2d
	$"모양".mesh.material.albedo_color = NamedColorList.color_list.pick_random()[0]
	$"모양".rotation.z = randf_range(-PI,PI)
	rotate_v = randf_range(-5,5)

	var old = field.set_at(p2d, Things.Apple)
	assert(old == null, "%s pos not empty %s" % [self, old])
	position = get_pos3d()
	return self

func get_pos3d() -> Vector3:
	return Settings.vector2i_to_vector3(pos2d)

func delete() -> void:
	var old = field.del_at(pos2d)
	assert( old == Things.Apple, "not %s at %s %s" % [self, pos2d , old] )

func _process(delta: float) -> void:
	$"모양".rotate_x(delta*rotate_v)
