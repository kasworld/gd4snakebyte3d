extends Node3D
class_name Apple

var number :int
var pos2d :Vector2i
var field :PlacedThings
var rotate_v :float

func _to_string() -> String:
	return "Apple%d (%d,%d)" % [number, pos2d.x,pos2d.y]

func init(f :PlacedThings, n :int) -> Apple:
	number = n
	$"번호".text = "%d" % number
	field = f
	$"모양".mesh.material.albedo_color = Settings.LightColorList.pick_random()[0]
	$"모양".rotation.z = randf_range(-PI,PI)
	rotate_v = randf_range(-5,5)

	var pos := field.find_empty_pos(10)
	pos2d = pos
	assert(pos!=Vector2i(-1,-1), "fail to find empty pos in field")
	var old = field.set_at(pos, self)
	assert(old == null, "%s pos not empty %s" % [self, old])
	position = get_pos3d()
	return self

func get_pos2d() -> Vector2i:
	return pos2d

func get_pos3d() -> Vector3:
	return Settings.vector2i_to_vector3(pos2d)

func delete() -> void:
	var old = field.del_at(pos2d)
	assert( old is Apple, "not %s at %s %s" % [self, pos2d , old] )

func _process(delta: float) -> void:
	$"모양".rotate_x(delta*rotate_v)
