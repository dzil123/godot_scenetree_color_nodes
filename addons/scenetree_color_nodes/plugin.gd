@tool
extends EditorPlugin

var plugin: EditorInspectorPlugin
var scenedock_editor: Node
var scenedock_tree: Tree

const Util = preload("util.gd")


func _enter_tree():
	var base_control = get_editor_interface().get_base_control()
	var scenedock = Util.get_child_of_type(base_control, "SceneTreeDock", true)
	scenedock_editor = Util.get_child_of_type(scenedock, "SceneTreeEditor")
	scenedock_tree = Util.get_child_of_type(scenedock_editor, "Tree")

	plugin = preload("res://addons/scenetree_color_nodes/inspector_plugin.gd").new()
	plugin.editor_scale = get_editor_interface().get_editor_scale()
	plugin.icon = base_control.get_theme_icon("LabelSettings", "EditorIcons")
	plugin.editor_inspector = get_editor_interface().get_inspector()
	plugin.undo_redo = get_undo_redo()
	add_inspector_plugin(plugin)


func _exit_tree():
	remove_inspector_plugin(plugin)

	scenedock_editor.call("update_tree")


func _process(_delta):
	process_scenedock()


func process_scenedock():
	var current_item: TreeItem = scenedock_tree.get_root()
	while current_item != null:
		process_item(current_item)
		current_item = current_item.get_next_visible()


func process_item(item: TreeItem):
	var nodepath: NodePath = item.get_metadata(0)
	var node: Node = scenedock_tree.get_node_or_null(nodepath)
	if node == null:
		return

	if Util.node_has_color(node):
		var color = node.get_meta(Util.METADATA_NAME, Color.TRANSPARENT)
		item.set_custom_bg_color(0, color)
	else:
		item.clear_custom_bg_color(0)
