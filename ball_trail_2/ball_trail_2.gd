extends Node3D

class_name BallTrail

var velocity :Vector3
var bounce_fn :Callable
var radius :float
var speed_max :float
var speed_min :float
var obj_cursor :int
var current_color :Color
var current_rot :float
var current_rot_accel :float
var multi_ball :MultiMeshInstance3D
var multimesh :MultiMesh

func init(bnfn :Callable, r :float, count :int, t:int, pos :Vector3) -> BallTrail:
	radius = r
	bounce_fn = bnfn
	speed_max = radius * 120
	speed_min = radius * 80
	velocity = Vector3( (randf()-0.5)*speed_max,(randf()-0.5)*speed_max,(randf()-0.5)*speed_max)
	current_color = NamedColorList.color_list.pick_random()[0]
	current_rot_accel = rand_rad()
	make_mat_multi(new_mesh_by_type(t,radius), count, pos)
	return self

func make_mat_multi(mesh :Mesh,count :int, pos:Vector3):
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

	for i in multimesh.visible_instance_count:
		multimesh.set_instance_color(i,current_color)
		var ball_position = pos
		var t = Transform3D(Basis(), ball_position)
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

func _process(delta: float) -> void:
	move(delta)

func move(delta :float) -> void:
	var old_cursor = obj_cursor
	obj_cursor +=1
	obj_cursor %= multimesh.instance_count
	move_ball(delta, old_cursor, obj_cursor)

func move_ball(delta: float, oldi :int, newi:int) -> void:
	var oldpos = multimesh.get_instance_transform(oldi).origin
	var newpos = oldpos + velocity * delta
	var bn = bounce_fn.call(oldpos,newpos,radius)
	set_multi_pos(newi, bn.pos)
	for i in 3:
		# change vel on bounce
		if bn.bounced[i] != 0 :
			velocity[i] = -random_positive(speed_max/2)*bn.bounced[i]

	if bn.bounced != Vector3i.ZERO:
		current_color = NamedColorList.color_list.pick_random()[0]
		current_rot_accel = rand_rad()
	set_multi_color(newi, current_color)
	current_rot += current_rot_accel
	set_multi_rotation(newi, velocity.normalized(), current_rot)

	if velocity.length() > speed_max:
		velocity = velocity.normalized() * speed_max
	if velocity.length() < speed_min:
		velocity = velocity.normalized() * speed_min

func new_mesh_by_type(t :int, r :float) -> Mesh:
	var mesh:Mesh
	match t%7:
		0:
			mesh = SphereMesh.new()
			mesh.radius = r
			mesh.height = r
		1:
			mesh = BoxMesh.new()
			mesh.size = Vector3(r,r,r)*1.5
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

func rand_rad() -> float:
	return randf_range(-PI,PI)/100

func random_positive(w :float) -> float:
	return randf_range(w/10,w)
