extends Node3D
class_name StepOverGauge

func init(count :int, sz :float) -> StepOverGauge:
	var mesh = BoxMesh.new()
	mesh.size = Vector3(1, sz / count /1.1 , 1)

	$MultiMeshShape.init(mesh, Color.WHITE, count, Vector3.ZERO)
	for i in count:
		var rate := (i as float) / (count as float)
		var pos3d := Vector3(0,rate*sz,0) # grow upward
		$MultiMeshShape.set_inst_pos(i, pos3d)
		$MultiMeshShape.set_inst_color(i, lerp(Color.GREEN, Color.RED, rate))
	return self

func set_value( i :int) -> void:
	$MultiMeshShape.set_visible_count(i)
