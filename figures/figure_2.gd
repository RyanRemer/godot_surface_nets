extends Node3D

@onready var point_view: PointView = $PointView;

func _ready():
	var size = 6;
	for x in range(-size, size):
		for y in range(-size, size):
			for z in range(-size, size):
				var sample_position = Vector3i(x,y,z);
				var sample_value = get_sample_value(sample_position);
				if sample_value < 0:
					point_view.add_point(sample_position, Colors.BLUE_B);
				else:
					point_view.add_point(sample_position, Colors.PURPLE_B);
	
const CENTER := Vector3.ZERO;
const RADIUS: float = 5.0;	

func get_sample_value(index: Vector3i) -> float:	
	return CENTER.distance_to(index) - RADIUS;
