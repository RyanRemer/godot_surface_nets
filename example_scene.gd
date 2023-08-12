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
		
	
