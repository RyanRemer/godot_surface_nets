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
	var surface_position = get_surface_position(index);
	point_view.add_point(surface_position, Colors.PURPLE_A)
	surfaceTool.add_vertex(surface_position);
	
func get_surface_position(index: Vector3i) -> Vector3:
	var main_sample_value = get_sample_value(index);
	var total_offset = Vector3(0,0,0);
	
	for axis_index in range(3):
		var axis = AXIS[axis_index];
		var neighbor_sample_value = get_sample_value(index + axis);
		
		if main_sample_value < 0 and neighbor_sample_value < 0:
			pass;
		elif main_sample_value >= 0 and neighbor_sample_value >= 0:
			pass;
		else:
			var ratio = (0.0 - main_sample_value) / (neighbor_sample_value - main_sample_value);
			var offset: Vector3 = axis * ratio;
			total_offset += offset;
	
	return Vector3(index) + total_offset;
	
func create_surface_mesh():
	for x in range(-5, 5):
		for y in range(-5, 5):
			for z in range(-5, 5):
				create_surface_mesh_quad(Vector3i(x,y,z));
				

