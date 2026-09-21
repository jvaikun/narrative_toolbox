@tool
extends Control

const PATH = "res://timelines/"

@onready var file_list = $Content/Timelines/List
@onready var inspector = $Content/Editor/EditorInspector

func _ready() -> void:
	var files = ResourceLoader.list_directory(PATH)
	file_list.clear()
	for file in files:
		if file.contains(".tres"):
			file_list.add_item(file)
			file_list.set_item_metadata(-1, PATH + file)


func _on_list_item_selected(index: int) -> void:
	var file_path = file_list.get_item_metadata(index)
	var timeline = load(file_path) as Timeline
	inspector.edit(timeline)
