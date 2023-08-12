extends Node3D

@onready var point_view = $PointView;

func _ready():
	var main_position = Vector3(0,0,0);
	point_view.add_point(Vector3(0,0,0), Colors.BLUE_D);
	
	var main_sample = -1.0;
	var total_offset = Vector3(0,0,0);
	const AXIS = [Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)]
	var neighbor_samples = [1.0, 1.0, 1.0];
	
	for axis_index in range(3):
		var axis = AXIS[axis_index];
		var neighbor_sample = neighbor_samples[axis_index];
		var ratio = (0.0 - main_sample) / (neighbor_sample - main_sample);
		var offset: Vector3 = axis * ratio;
		total_offset += offset;
		point_view.add_point(main_position + offset, Colors.GOLD_D);
		point_view.add_point(main_position + axis, Colors.LIGHT_PINK);
		
	point_view.add_point(main_position + total_offset, Colors.GOLD_A);
		
	
func get_surface_position(index: Vector3i):
	const AXIS = [Vector3i(1,0,0),Vector3i(0,1,0),Vector3i(0,0,1)]
	var main_sample_value = get_sample_value(index);
	var total_offset = Vector3(0,0,0);
	
	for axis_index in range(3):
		var axis = AXIS[axis_index];
		var neighbor_sample_value = get_sample_value(index + axis);
		var ratio = (0.0 - main_sample_value) / (neighbor_sample_value - main_sample_value);
		var offset: Vector3 = axis * ratio;
		total_offset += offset;
	
	return index + total_offset;
		
func get_sample_value(index: Vector3i):
	pass;
