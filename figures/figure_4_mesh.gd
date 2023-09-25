extends MeshInstance3D

@onready var point_view: PointView = $"../PointView";
var surface_tool := SurfaceTool.new();

func _ready():
	point_view.add_point(Vector3(0,0,0), Colors.BLUE_B);
	point_view.add_point(Vector3(1,0,0), Colors.PURPLE_B);
	point_view.add_point(Vector3(0,1,0), Colors.BLUE_B);
	point_view.add_point(Vector3(0,0,1), Colors.BLUE_B);
	
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES);
	surface_tool.set_color(Colors.BLUE_B);
	add_quad(Vector3i(0,0,0), 0);
	mesh = surface_tool.commit();

func add_quad(index: Vector3i, axis_index: int):
	var points = get_quad_points(index, axis_index);
	
	surface_tool.set_normal(AXIS[axis_index]);
	
	add_vertex(points[0])
	add_vertex(points[1])
	add_vertex(points[2])

	add_vertex(points[0])
	add_vertex(points[2])
	add_vertex(points[3])
	
func add_reversed_quad(index: Vector3i, axis_index: int):
	var points = get_quad_points(index, axis_index);
	
	surface_tool.set_normal(-AXIS[axis_index]);
	
	add_vertex(points[0])
	add_vertex(points[2])
	add_vertex(points[1])

	add_vertex(points[0])
	add_vertex(points[3])
	add_vertex(points[2])
			
func get_quad_points(index: Vector3i, axis_index: int):
	return [
		index + QUAD_POINTS[axis_index][0],
		index + QUAD_POINTS[axis_index][1],
		index + QUAD_POINTS[axis_index][2],
		index + QUAD_POINTS[axis_index][3],
	];
		
func add_vertex(index: Vector3i):	
	surface_tool.add_vertex(Vector3(index) + Vector3.ONE * 0.5);

# Constants
const AXIS := [
	Vector3i(1,0,0),	
	Vector3i(0,1,0),	
	Vector3i(0,0,1),	
];

# The 4 relative indexes of the corners of a Quad that is orthogonal to each axis
const QUAD_POINTS := [
	# x axis
	[
		Vector3i(0,0,-1),
		Vector3i(0,-1,-1),
		Vector3i(0,-1,0),
		Vector3i(0,0,0)
	],	
	# y axis
	[
		Vector3i(0,0,-1),
		Vector3i(0,0,0),
		Vector3i(-1,0,0),
		Vector3i(-1,0,-1)
	],	
	# z axis
	[
		Vector3i(0,0,0),
		Vector3i(0,-1,0),
		Vector3i(-1,-1,0),
		Vector3i(-1,0,0)
	],	
];

const EDGES := [
	# Edges on min Z axis
	[Vector3i(0,0,0),Vector3i(1,0,0)],
	[Vector3i(1,0,0),Vector3i(1,1,0)],
	[Vector3i(1,1,0),Vector3i(0,1,0)],
	[Vector3i(0,1,0),Vector3i(0,0,0)],
	# Edges on max Z axis
	[Vector3i(0,0,1),Vector3i(1,0,1)],
	[Vector3i(1,0,1),Vector3i(1,1,1)],
	[Vector3i(1,1,1),Vector3i(0,1,1)],
	[Vector3i(0,1,1),Vector3i(0,0,1)],
	# Edges connecting min Z to max Z
	[Vector3i(0,0,0),Vector3i(0,0,1)],
	[Vector3i(1,0,0),Vector3i(1,0,1)],
	[Vector3i(1,1,0),Vector3i(1,1,1)],
	[Vector3i(0,1,0),Vector3i(0,1,1)],
]
