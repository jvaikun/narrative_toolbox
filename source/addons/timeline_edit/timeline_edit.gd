@tool
extends EditorPlugin

const PANEL_OBJ = preload("res://addons/timeline_edit/editor_dock.tscn")

var panel_inst : Control
var file_list : Array = []


func _enter_tree() -> void:
	panel_inst = PANEL_OBJ.instantiate()
	EditorInterface.get_editor_main_screen().add_child(panel_inst)
	_make_visible(false)


func _exit_tree():
	if panel_inst:
		panel_inst.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if panel_inst:
		panel_inst.visible = visible


func _get_plugin_name():
	return "Timeline Editor"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
