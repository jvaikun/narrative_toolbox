@tool
extends PanelContainer

@onready var type: Label = %Type
@onready var btn_fold: Button = %BtnFold
@onready var body: PanelContainer = %Body

var data = null


func set_data(value):
	data = value
	if data is ChoiceBranch:
		type.text = "[Branch]"
		var event_obj = load("res://addons/timeline_edit/events/event_base.tscn")
		var new_cont = VBoxContainer.new()
		body.add_child(new_cont)
		for i in data.events.size():
			var new_event = event_obj.instantiate()
			new_cont.add_child(new_event)
			new_event.set_data(data.events[i])
	if data is EventAudio:
		type.text = "[Audio]"
	if data is EventChoice:
		type.text = "[Choice]"
		var event_obj = load("res://addons/timeline_edit/events/event_base.tscn")
		var new_cont = VBoxContainer.new()
		body.add_child(new_cont)
		for i in data.choices.size():
			var new_event = event_obj.instantiate()
			new_cont.add_child(new_event)
			new_event.set_data(data.choices[i])
	if data is EventImage:
		type.text = "[Image]"
		var new_texture = TextureRect.new()
		body.add_child(new_texture)
		new_texture.custom_minimum_size = Vector2(64, 64)
		new_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		new_texture.texture = data.image
	if data is EventText:
		type.text = "[Text]"
		var new_edit = TextEdit.new()
		body.add_child(new_edit)
		new_edit.custom_minimum_size.y = 128
		new_edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
		new_edit.text = data.lines
		new_edit.hide()
		new_edit.show()


func _on_btn_fold_toggled(toggled_on: bool) -> void:
	btn_fold.text = "Hide" if toggled_on else "Show"
	body.visible = toggled_on
