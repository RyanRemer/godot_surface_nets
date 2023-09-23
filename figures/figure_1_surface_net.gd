extends MeshInstance3D

var surfaceTool := SurfaceTool.new();
@export var noise: Noise;

func _ready():
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES);
	surfaceTool.set_color(Colors.BLUE_D);
	surfaceTool.set_smooth_group(-1)
	create_surface_mesh();
	surfaceTool.generate_normals();
	mesh = surfaceTool.commit();

func get_sample_value(index: Vector3i) -> float:	
	return max(abs(index.x) - 16.0, noise.get_noise_3dv(index))
	
func get_rect_surface_distance(index: Vector3i, size: int):
	return max(
		abs(index.x) - size,
		abs(index.y) - size,
		abs(index.z) - size
	);
	
# Step 6: Create Surface
func create_surface_mesh(size: int = 16):
	for x in range(-size, size):
		for y in range(-size, size):
			for z in range(-size, size):
				create_surface_mesh_quad(Vector3i(x,y,z));
				
				
func create_surface_mesh_quad(index: Vector3i):
	for axis_index in range(AXIS.size()):
		var axis = AXIS[axis_index];
		var sample_value1 = get_sample_value(index);
		var sample_value2 = get_sample_value(index + axis);
		
		if sample_value1 < 0 and sample_value2 >= 0:
			add_quad(index, axis_index);
		elif sample_value1 >= 0 and sample_value2 < 0:
			add_reversed_quad(index, axis_index);
			
func add_quad(index: Vector3i, axis_index: int):
	var points = get_quad_points(index, axis_index);
	
	surfaceTool.set_normal(AXIS[axis_index]);
	
	add_vertex(points[0])
	add_vertex(points[1])
	add_vertex(points[2])

	add_vertex(points[0])
	add_vertex(points[2])
	add_vertex(points[3])
	
func add_reversed_quad(index: Vector3i, axis_index: int):
	var points = get_quad_points(index, axis_index);
	
	surfaceTool.set_normal(-AXIS[axis_index]);
	
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
	var sample_value = get_sample_value(index);
	var surface_position = get_surface_position(index);
	var surface_gradient = get_surface_gradient(index, sample_value);
	surfaceTool.add_vertex(surface_position);
	
func get_surface_position(index: Vector3i):
	var total := Vector3.ZERO;
	var surface_edge_count = 0;
	
	for edge_offsets in EDGES:
		var position_a = Vector3(index + edge_offsets[0]);
		var sample_a = get_sample_value(position_a);
		var position_b = Vector3(index + edge_offsets[1])
		var sample_b = get_sample_value(position_b);
		
		if sample_a * sample_b <= 0:
			# if different signs
			surface_edge_count += 1;
			total += position_a.lerp(position_b, abs(sample_a) / (abs(sample_a) + abs(sample_b)));
	
	if surface_edge_count == 0:
		return Vector3(index) + Vector3.ONE * 0.5;
	
	return total / surface_edge_count;
	
func get_surface_gradient(index: Vector3i, sample_value: float) -> Vector3:
	return Vector3(
		sample_value - get_sample_value(index + AXIS[0]),
		sample_value - get_sample_value(index + AXIS[1]),
		sample_value - get_sample_value(index + AXIS[2])
	).normalized();	

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
