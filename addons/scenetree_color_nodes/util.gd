@tool

const PROPERTY_NAME = "scene_tree_color"


static func node_has_color(node: Node):
	var value = node.get_meta(PROPERTY_NAME, 0)
	return typeof(value) == TYPE_COLOR


static func get_child_of_type(node: Node, type: String, recursive: bool = false) -> Node:
	var l = node.find_children("", type, recursive, false)
	assert(len(l) == 1)
	return l[0]
