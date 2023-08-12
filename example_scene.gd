extends Node3D

@onready var point_view = $PointView;

func _ready():
	point_view.add_point(Vector3(0,0,0), Colors.BLUE_D);
	point_view.add_point(Vector3(1,0,0), Colors.LIGHT_PINK);
	point_view.add_point(Vector3(0,1,0), Colors.LIGHT_PINK);
	point_view.add_point(Vector3(0,0,1), Colors.LIGHT_PINK);
	
	var main_sample = -1.0;
	const AXIS = [Vector3(1,0,0),Vector3(1,0,0),Vector3(1,0,0)]
	var neighbor_samples = [1.0, 1.0, 1.0];
	
	var axis = Vector3(1,0,0);
	var neighbor_sample = 1.0;
	var range = neighbor_sample - main_sample;
	var desired = 0 - main_sample;
	var ratio = desired / range;
	var offset: Vector3 = axis * ratio;
	
	point_view.add_point(offset, Colors.GOLD_D);
	
	
	
