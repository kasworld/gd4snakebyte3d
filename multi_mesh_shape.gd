extends Node3D
class_name MultiMeshShape

var multi_ball :MultiMeshInstance3D
var multimesh :MultiMesh

func init(mesh :Mesh, co :Color, count :int, shape_type:ShapeType, pos :Vector3) -> MultiMeshShape:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.WHITE
	mat.vertex_color_use_as_albedo = true
	mesh.material = mat
	multimesh = MultiMesh.new()
	multimesh.mesh = mesh
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_colors = true # before set instance_count
	# Then resize (otherwise, changing the format is not allowed).
	multimesh.instance_count = count
	multimesh.visible_instance_count = count
	multi_ball = MultiMeshInstance3D.new()
	multi_ball.multimesh = multimesh
	add_child(multi_ball)
	return self

	for i in multimesh.visible_instance_count:
		multimesh.set_instance_color(i,co)
		var t = Transform3D(Basis(), pos)
		multimesh.set_instance_transform(i,t)

func set_multi_rotation(i :int,axis :Vector3, rot :float) -> void:
	var t = multimesh.get_instance_transform(i)
	t = t.rotated_local(axis, rot)
	multimesh.set_instance_transform(i,t )

func set_multi_pos(i :int, pos :Vector3) -> void:
	var t = multimesh.get_instance_transform(i)
	t.origin = pos
	multimesh.set_instance_transform(i,t )

func set_multi_color(i, co :Color) -> void:
	multimesh.set_instance_color(i,co)

enum ShapeType {Sphere, Box, Prism, Text, Torus, Capsule, Cylinder}

func new_mesh_by_type(t :ShapeType, r :float) -> Mesh:
	var mesh:Mesh
	match t:
		0:
			mesh = SphereMesh.new()
			mesh.radius = r
			mesh.height = r
		1:
			mesh = BoxMesh.new()
			mesh.size = Vector3(r,r,r)*2
		2:
			mesh = PrismMesh.new()
			mesh.size = Vector3(r,r,r)*1.5
		3:
			mesh = TextMesh.new()
			mesh.depth = r/4
			mesh.pixel_size = r / 10
			mesh.font_size = r*200
			mesh.text = "A"
		4:
			mesh = TorusMesh.new()
			mesh.inner_radius = r/2
			mesh.outer_radius = r
		5:
			mesh = CapsuleMesh.new()
			mesh.height = r*2
			mesh.radius = r*0.5
		6:
			mesh = CylinderMesh.new()
			mesh.height = r*2
			mesh.bottom_radius = r
			mesh.top_radius = 0
	return mesh
