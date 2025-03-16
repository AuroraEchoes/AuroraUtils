class_name AuroraUtils
class Constants:
	const ADJACENT: Array[Vector2i] = [
		Vector2i.LEFT,
		Vector2i.UP,
		Vector2i.RIGHT,
		Vector2i.DOWN
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

	func fill(val) -> void:
		for i in self.size.x * self.size.y:
			contents[i] = val
	
	func in_grid(pos: Vector2i) -> bool:
		return pos.x >= 0 && pos.x < self.size.x && pos.y >= 0 && pos.y < self.size.y
	
	func adjacent(pos: Vector2i) -> Array:
		return _get_offset_tiles(pos, Constants.ADJACENT)

	func adjacent_diagonal(pos: Vector2i) -> Array:
		return _get_offset_tiles(pos, Constants.ADJACENT_DIAGONAL)

	func _get_offset_tiles(pos: Vector2i, offsets: Array[Vector2i]) -> Array:
		var vals = []
		for offset in offsets:
			var offset_pos = pos + offset
			if in_grid(offset_pos):
				vals.push_back(get_cell(offset_pos))
		return vals

	func _coordinate_to_idx(coordinate: Vector2i):
		return coordinate.y * self.size.x + coordinate.x
