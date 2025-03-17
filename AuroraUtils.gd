class_name AuroraUtils

static func in_range(i, min_val, max_val) -> bool:
	return i >= min_val and i <= max_val

class Constants:
	const ADJACENT: Array[Vector2i] = [
		Vector2i.LEFT,
		Vector2i.UP,
		Vector2i.RIGHT,
		Vector2i.DOWN
	]

	const DIAGONAL: Array[Vector2i] = [
		Vector2i.LEFT + Vector2i.UP,
		Vector2i.UP + Vector2i.RIGHT,
		Vector2i.RIGHT + Vector2i.DOWN,
		Vector2i.DOWN + Vector2i.LEFT
	]

	const ADJACENT_DIAGONAL: Array[Vector2i] = [
		Vector2i.LEFT,
		Vector2i.LEFT + Vector2i.UP,
		Vector2i.UP,
		Vector2i.UP + Vector2i.RIGHT,
		Vector2i.RIGHT,
		Vector2i.RIGHT + Vector2i.DOWN,
		Vector2i.DOWN,
		Vector2i.DOWN + Vector2i.LEFT
	]

	const FULL_CIRCLE: float = TAU
	const HALF_CIRCLE: float = TAU / 2.0
	const THIRD_CIRCLE: float = TAU / 3.0
	const QUARTER_CIRCLE: float = TAU / 4.0
	const EIGTH_CIRCLE: float = TAU / 8.0

	const SQRT_TWO: float = sqrt(2.0)

class Grid:

	var contents: Array = []
	var size: Vector2i

	func _init(width: int, height: int) -> void:
		self.size = Vector2i(width, height)
		for _i in self.size.x * self.size.y:
			contents.push_back(null)
	
	func set_cell(val, pos: Vector2i) -> void:
		contents[_coordinate_to_idx(pos)] = val
	
	func get_cell(pos: Vector2i):
		return contents[_coordinate_to_idx(pos)]
	
	func filled_cells() -> Array:
		var filled: Array = []
		for cell in contents:
			if cell != null:
				filled.push_back(cell)
		return filled

	func filled_positions() -> Array[Vector2i]:
		var filled: Array[Vector2i] = []
		for i in range(contents.size()):
			if contents[i] != null:
				filled.push_back(_idx_to_coordinate(i))
		return filled

	func fill(val) -> void:
		for i in self.size.x * self.size.y:
			contents[i] = val
	
	func in_grid(pos: Vector2i) -> bool:
		return pos.x >= 0 && pos.x < self.size.x && pos.y >= 0 && pos.y < self.size.y
	
	func adjacent(pos: Vector2i) -> Array:
		return _get_offset_tiles(pos, Constants.ADJACENT)

	func adjacent_diagonal(pos: Vector2i) -> Array:
		return _get_offset_tiles(pos, Constants.ADJACENT_DIAGONAL)

	func diagonal(pos: Vector2i) -> Array:
		return _get_offset_tiles(pos, Constants.DIAGONAL)


	func _get_offset_tiles(pos: Vector2i, offsets: Array[Vector2i]) -> Array:
		var vals = []
		for offset in offsets:
			var offset_pos = pos + offset
			if in_grid(offset_pos) and get_cell(offset_pos) != null:
				vals.push_back(get_cell(offset_pos))
		return vals

	func _coordinate_to_idx(coordinate: Vector2i) -> int:
		return coordinate.y * self.size.x + coordinate.x

	func _idx_to_coordinate(idx: int) -> Vector2i:
		@warning_ignore("integer_division")
		return Vector2i(idx % size.x, floori(idx / size.x))

class GraphVertex:
	var contents
	var id: int
	var connections: Array[int]

	func _init(param_contents, param_id: int) -> void:
		contents = param_contents
		id = param_id
	
	func connected_to(other: GraphVertex):
		return connections.has(other.id)
	
class Graph:
	var vertices: Array[GraphVertex] = []

	func add_vertex(contents):
		var vertex_id = vertices.size()
		vertices.push_back(GraphVertex.new(contents, vertex_id))
	
	func connect_vertices(a: GraphVertex, b: GraphVertex):
		if !a.connections.has(b.id): a.connections.push_back(b.id)
		if !b.connections.has(a.id): b.connections.push_back(a.id)
	
	func vertex_from_id(id: int) -> GraphVertex:
		return vertices[id]
	
	func where(action: Callable) -> Array[GraphVertex]:
		var filtered: Array[GraphVertex] = []
		for vertex in vertices:
			if action.call(vertex):
				filtered.push_back(vertex)
		return filtered

	func _to_string() -> String:
		var buf: String = ""
		for vertex in vertices:
			var connection_buf: String = ""
			for conn in vertex.connections:
				connection_buf += str(conn) + ", "
			connection_buf = connection_buf.substr(0, connection_buf.length() - 2)
			buf += str(vertex.id) + " (" + str(vertex.contents) + ") → " + connection_buf
		return buf
