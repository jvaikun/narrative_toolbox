@tool
extends PanelContainer

@onready var title: LineEdit = %Title
@onready var btn_fold: Button = %BtnFold
@onready var body: VBoxContainer = %Body

var data : ChoiceBranch = null


func set_data(value):
	data = value
	title.text = data.title
	var event_obj
	for i in data.events.size():
		if data.events[i] is ChoiceBranch:
			event_obj = load("res://addons/timeline_edit/events/event_choice.tscn")
		if data.events[i] is EventAudio:
			event_obj = load("res://addons/timeline_edit/events/event_audio.tscn")
		if data.events[i] is EventChoice:
			event_obj = load("res://addons/timeline_edit/events/event_branch.tscn")
		if data.events[i] is EventClear:
			event_obj = load("res://addons/timeline_edit/events/event_clear.tscn")
		if data.events[i] is EventCondition:
			event_obj = load("res://addons/timeline_edit/events/event_condition.tscn")
		if data.events[i] is EventEnd:
			event_obj = load("res://addons/timeline_edit/events/event_end.tscn")
		if data.events[i] is EventImage:
			event_obj = load("res://addons/timeline_edit/events/event_image.tscn")
		if data.events[i] is EventJump:
			event_obj = load("res://addons/timeline_edit/events/event_jump.tscn")
		if data.events[i] is EventSetVar:
			event_obj = load("res://addons/timeline_edit/events/event_setvar.tscn")
		if data.events[i] is EventTag:
			event_obj = load("res://addons/timeline_edit/events/event_tag.tscn")
		if data.events[i] is EventText:
			event_obj = load("res://addons/timeline_edit/events/event_text.tscn")
		if data.events[i] is EventWait:
			event_obj = load("res://addons/timeline_edit/events/event_wait.tscn")
		var new_event = event_obj.instantiate()
		body.add_child(new_event)
		new_event.set_data(data.events[i])


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
