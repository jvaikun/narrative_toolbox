@tool
extends Control

const PATH = "res://timelines/"

@onready var event_adds = {
	"audio": $Content/Events/Media/BtnAudio,
	"choice": $Content/Events/Flow/BtnChoice,
	"image": $Content/Events/Media/BtnImage,
	"text": $Content/Events/Media/BtnText,
}
@onready var file_list = $Content/Timelines/List
@onready var inspector = $Content/Editor/EditorInspector
@onready var event_pane = $Content/Editor/Events
@onready var event_list = $Content/Editor/Events/List

var this_tl : Timeline = null


func _ready() -> void:
	var files = ResourceLoader.list_directory(PATH)
	file_list.clear()
	for file in files:
		if file.contains(".tres"):
			file_list.add_item(file)
			file_list.set_item_metadata(-1, PATH + file)
	for key in event_adds.keys():
		event_adds[key].pressed.connect(_add_event.bind(key))


func _add_event(event_id):
	if event_id not in event_adds.keys() or this_tl == null:
		return
	match event_id:
		"audio":
			print("Audio added")
			var new_event = EventAudio.new()
			this_tl.events.append(new_event)
		"choice":
			print("Choice added")
			var new_event = EventChoice.new()
			this_tl.events.append(new_event)
		"image":
			print("Image added")
			var new_event = EventImage.new()
			this_tl.events.append(new_event)
		"text":
			print("Text added")
			var new_event = EventText.new()
			this_tl.events.append(new_event)
	#notify_property_list_changed()


func _on_list_item_selected(index: int) -> void:
	var file_path = file_list.get_item_metadata(index)
	this_tl = load(file_path) as Timeline
	inspector.edit(this_tl)
	event_pane.hide()
	inspector.show()


func _on_btn_parse_pressed() -> void:
	if this_tl == null:
		return
	for event in event_list.get_children():
		event.queue_free()
	var event_obj
	for event in this_tl.events:
		if event is ChoiceBranch:
			event_obj = load("res://addons/timeline_edit/events/event_choice.tscn")
		if event is EventAudio:
			event_obj = load("res://addons/timeline_edit/events/event_audio.tscn")
		if event is EventChoice:
			event_obj = load("res://addons/timeline_edit/events/event_branch.tscn")
		if event is EventClear:
			event_obj = load("res://addons/timeline_edit/events/event_clear.tscn")
		if event is EventCondition:
			event_obj = load("res://addons/timeline_edit/events/event_condition.tscn")
		if event is EventEnd:
			event_obj = load("res://addons/timeline_edit/events/event_end.tscn")
		if event is EventImage:
			event_obj = load("res://addons/timeline_edit/events/event_image.tscn")
		if event is EventJump:
			event_obj = load("res://addons/timeline_edit/events/event_jump.tscn")
		if event is EventSetVar:
			event_obj = load("res://addons/timeline_edit/events/event_setvar.tscn")
		if event is EventTag:
			event_obj = load("res://addons/timeline_edit/events/event_tag.tscn")
		if event is EventText:
			event_obj = load("res://addons/timeline_edit/events/event_text.tscn")
		if event is EventWait:
			event_obj = load("res://addons/timeline_edit/events/event_wait.tscn")
		var new_event = event_obj.instantiate()
		event_list.add_child(new_event)
		new_event.set_data(event)
	inspector.hide()
	event_pane.show()


func _on_btn_refresh_pressed() -> void:
	var select_index = file_list.get_selected_items()[0]
	var file_path = file_list.get_item_metadata(select_index)
	this_tl = load(file_path) as Timeline
	inspector.edit(this_tl)
