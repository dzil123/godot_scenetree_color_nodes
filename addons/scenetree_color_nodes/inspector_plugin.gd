extends EditorInspectorPlugin

var editor_inspector: Node
var editor_scale = 1.0
var icon: Texture2D
var undo_redo: EditorUndoRedoManager

const Util = preload("util.gd")


func _can_handle(object):
	return object is Node


func _parse_end(object):
	if not (object is Node):
		return

	var node: Node = object
	if Util.node_has_color(node):
		return


	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 4) * editor_scale
	add_custom_control(spacer)


	var btn = Button.new()

	var callback = func():
		if not Util.node_has_color(node):
			undo_redo.create_action("Set Custom Color")
			undo_redo.add_do_method(node, &"set_meta", Util.METADATA_NAME, Color(Color.WHITE, 0.25))
			undo_redo.add_undo_method(node, &"remove_meta", Util.METADATA_NAME)
			undo_redo.commit_action()
		btn.queue_free()

	btn.text = "Set Custom Color"
	btn.pressed.connect(callback)
	btn.theme_type_variation = "InspectorActionButton"
	btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	btn.icon = icon
	add_custom_control(btn)
