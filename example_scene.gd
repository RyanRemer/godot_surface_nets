extends Node3D

@onready var point_view = $PointView;

func _ready():
	for x in range(-10, 10):
		for y in range(-10, 10):
			for z in range(-10, 10):
				point_view.add_point(Vector3(x,y,z), Colors.MAROON_B);
