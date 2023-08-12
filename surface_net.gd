extends MeshInstance3D

var surfaceTool := SurfaceTool.new();

func _ready():
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	surfaceTool.set_color(Colors.BLUE_D);
	create_surface_mesh();
	mesh = surfaceTool.commit();

# Step 1: Define Surface Distance
const CENTER := Vector3.ZERO;
const RADIUS: float = 5.0;	

func get_surface_distance(index: Vector3) -> float:
	return RADIUS - CENTER.distance_to(index);

# Step 6: Create Surface
const AXIS := [
	Vector3(1,0,0),	
	Vector3(0,1,0),	
	Vector3(0,0,1),	
];

# The 4 relative indexes of the corners of a Quad that is orthogonal to each axis
const QUAD_POINTS := [
	# x axis
	[
		Vector3(0,0,-1),
		Vector3(0,-1,-1),
		Vector3(0,-1,0),
		Vector3(0,0,0)
	],	
	# y axis
	[
		Vector3(0,0,-1),
		Vector3(0,0,0),
		Vector3(-1,0,0),
		Vector3(-1,0,-1)
	],	
	# z axis
	[
		Vector3(0,0,0),
		Vector3(0,-1,0),
		Vector3(-1,-1,0),
		Vector3(-1,0,0)
	],	
];

func create_surface_mesh_quad(index: Vector3):
	for axis_index in range(AXIS.size()):
		var axis = AXIS[axis_index];
		var sample_value1 = get_surface_distance(index);
		var sample_value2 = get_surface_distance(index + axis);
		
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
	surfaceTool.add_vertex(points[0])
	surfaceTool.add_vertex(points[2])
	surfaceTool.add_vertex(points[1])

	surfaceTool.add_vertex(points[0])
	surfaceTool.add_vertex(points[3])
	surfaceTool.add_vertex(points[2])
	pass;
	
func add_reversed_quad(points):
	surfaceTool.add_vertex(points[0])
	surfaceTool.add_vertex(points[1])
	surfaceTool.add_vertex(points[2])

	surfaceTool.add_vertex(points[0])
	surfaceTool.add_vertex(points[2])
	surfaceTool.add_vertex(points[3])
	pass;
	
func create_surface_mesh():
	for x in range(-10, 10):
		for y in range(-10, 10):
			for z in range(-10, 10):
				create_surface_mesh_quad(Vector3(x,y,z));
				

