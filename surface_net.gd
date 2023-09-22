extends MeshInstance3D

var surfaceTool := SurfaceTool.new();
@export var point_view: PointView;

func _ready():
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	surfaceTool.set_color(Colors.BLUE_D);
	create_surface_mesh();
	mesh = surfaceTool.commit();

# Step 1: Define Surface Distance
const CENTER := Vector3.ZERO;
const RADIUS: float = 5.0;	

func get_sample_value(index: Vector3i) -> float:
	return RADIUS - CENTER.distance_to(index);

# Step 6: Create Surface
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

func create_surface_mesh_quad(index: Vector3i):
	for axis_index in range(AXIS.size()):
		var axis = AXIS[axis_index];
		var sample_value1 = get_sample_value(index);
		var sample_value2 = get_sample_value(index + axis);
		
		var points = [
				index + QUAD_POINTS[axis_index][0],
				index + QUAD_POINTS[axis_index][1],
				index + QUAD_POINTS[axis_index][2],
				index + QUAD_POINTS[axis_index][3],
			];
		
		if sample_value1 < 0 and sample_value2 >= 0:
			surfaceTool.set_normal(axis * -1);
			add_quad(points);
		elif sample_value1 >= 0 and sample_value2 <= 0:
			surfaceTool.set_normal(axis);
			add_reversed_quad(points);

func add_quad(points):
	add_vertex(points[0])
	add_vertex(points[2])
	add_vertex(points[1])

	add_vertex(points[0])
	add_vertex(points[3])
	add_vertex(points[2])
	
func add_reversed_quad(points):
	add_vertex(points[0])
	add_vertex(points[1])
	add_vertex(points[2])

	add_vertex(points[0])
	add_vertex(points[2])
	add_vertex(points[3])
	
func add_vertex(index: Vector3i):
	var sample_value = get_sample_value(index);
	var surface_gradient = get_surface_gradient(index, sample_value);
	var sample_position = Vector3(index);
	
	var surface_position = sample_position + surface_gradient * sample_value
	
	surfaceTool.set_normal(surface_gradient);
	surfaceTool.add_vertex(surface_position);
	point_view.add_point(Vector3(surface_position), Colors.PURPLE_A)
	
func get_surface_gradient(index: Vector3i, sample_value: float) -> Vector3:
	return Vector3(
		sample_value - get_sample_value(index + AXIS[0]),
		sample_value - get_sample_value(index + AXIS[1]),
		sample_value - get_sample_value(index + AXIS[2])
	).normalized();
	
func create_surface_mesh(size: int = 6):
	for x in range(-size, size):
		for y in range(-size, size):
			for z in range(-size, size):
				create_surface_mesh_quad(Vector3i(x,y,z));
				

