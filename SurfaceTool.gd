extends Node

var LINE_WIDTH = 0.5

var half_line_width = LINE_WIDTH / 2
var start_position = Vector3()
var drag = false

var st = SurfaceTool.new()
var ig = ImmediateGeometry.new()

func _ready():
	add_child(ig)

func generate_strip(start_position, end_position):
	var tangent = end_position - start_position
	var bitangent = Vector3.UP.cross(tangent).normalized()
	var normal = tangent.cross(bitangent)
	var offset = bitangent * half_line_width
	
	var vertices = Array()
	vertices.push_back(start_position - offset)
	vertices.push_back(start_position + offset)
	vertices.push_back(end_position - offset)
	vertices.push_back(end_position + offset)
	
	return [vertices, normal]

func draw_line_preview(start_position, end_position):
	var strip = generate_strip(start_position, end_position)
	
	ig.clear()
	ig.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	ig.set_color(Color.white)
	ig.set_normal(strip[1])
	for v in strip[0]:
		ig.add_vertex(v)
	ig.end()

func create_line(start_position, end_position):
	var strip = generate_strip(start_position, end_position)
	
	st.begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	st.add_color(Color.white)
	st.add_normal(strip[1])
	for v in strip[0]:
		st.add_vertex(v)
	
	var mi = MeshInstance.new()
	mi.mesh = st.commit()
	add_child(mi)

func mouse_motion(mouse_position):
	if drag:
		draw_line_preview(start_position, mouse_position)

func mouse_button(event, click_position):
	if event.button_index == BUTTON_LEFT:
		if event.pressed:
			start_position = click_position
			drag = true
		else:
			drag = false
			ig.clear()
			create_line(start_position, click_position)

func _on_StaticBody_input_event(_camera, event, click_position, _click_normal, _shape_idx):
	if event is InputEventMouseMotion:
		mouse_motion(click_position)
	if event is InputEventMouseButton:
		mouse_button(event, click_position)
