extends Node3D

@onready var point_view: PointView = $PointView;

func _ready():
	point_view.add_point(Vector3(0,0,0), Colors.BLUE_B);
	point_view.add_point(Vector3(1,0,0), Colors.BLUE_B);
	point_view.add_point(Vector3(0,1,0), Colors.BLUE_B);
	point_view.add_point(Vector3(0,0,1), Colors.BLUE_B);
