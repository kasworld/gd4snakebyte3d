class_name ShapeLib

enum Shape {Sphere, Box, Prism, Text, Torus, Capsule, Cylinder}

static func new_mesh_by_type(t :Shape, r :float) -> Mesh:
	var mesh:Mesh
	match t:
		0:
			mesh = SphereMesh.new()
			mesh.radius = r
			mesh.height = r*2
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
